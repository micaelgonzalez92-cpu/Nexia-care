#!/usr/bin/env python3
"""NEXIA Local Worker v0.1 — safe-by-default local execution core."""
from __future__ import annotations
import argparse, hashlib, json, os, subprocess, sys, time
from datetime import datetime, timezone
from pathlib import Path

VERSION = "0.1.0"
AUTO_AUTHORITIES = {"GREEN", "GREEN_INTERNAL"}
ALLOWED_ACTIONS = {"HEALTH_CHECK", "RUN_NEXIA_PYTHON_TESTS"}

def now():
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

def canon(v):
    return json.dumps(v, sort_keys=True, separators=(",", ":"), ensure_ascii=False)

def load(path, default):
    path = Path(path)
    if not path.exists(): return default
    return json.loads(path.read_text(encoding="utf-8"))

def write(path, value):
    path = Path(path); path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    os.replace(tmp, path)

def fingerprint(task):
    material = {k: task.get(k) for k in ("task_id", "action", "authority")}
    material["payload"] = task.get("payload", {})
    return hashlib.sha256(canon(material).encode()).hexdigest()

class Worker:
    def __init__(self, state_dir, queue_file, control_file, status_file):
        self.state_dir = Path(state_dir); self.state_dir.mkdir(parents=True, exist_ok=True)
        self.queue_file = Path(queue_file); self.control_file = Path(control_file); self.status_file = Path(status_file)
        self.ledger_file = self.state_dir / "ledger.json"
        self.latch_file = self.state_dir / "stop_latch.json"
        self.heartbeat_file = self.state_dir / "heartbeat.json"

    def heartbeat(self, state, task_id=None):
        write(self.heartbeat_file, {"schema_version":1,"worker_version":VERSION,"timestamp":now(),"state":state,"task_id":task_id})

    def status(self, **kw):
        out = {"schema_version":1,"worker_version":VERSION,"updated_at":now(), **kw}
        write(self.status_file, out); return out

    def stopped(self):
        latch = load(self.latch_file, {"stopped":False})
        if latch.get("stopped"): return True
        control = load(self.control_file, {"desired_state":"RUN"})
        if str(control.get("desired_state","RUN")).upper() == "STOP":
            write(self.latch_file, {"stopped":True,"latched_at":now(),"reason":control.get("reason") or "REMOTE_STOP","worker_version":VERSION})
            return True
        return False

    def rearm_local(self):
        # Remote RUN never clears STOP. Re-arm must be a local explicit action.
        write(self.latch_file, {"stopped":False,"latched_at":None,"reason":"LOCAL_EXPLICIT_REARM","rearmed_at":now(),"worker_version":VERSION})

    def validate(self, task):
        missing = [k for k in ("task_id","action","authority") if not task.get(k)]
        if missing: return "MISSING_FIELDS:" + ",".join(missing)
        if str(task["action"]) not in ALLOWED_ACTIONS: return "ACTION_NOT_ALLOWLISTED"
        if str(task["authority"]).upper() not in AUTO_AUTHORITIES: return "AUTHORITY_REQUIRES_HUMAN_GATE"
        if task.get("external_effects"): return "EXTERNAL_EFFECTS_FORBIDDEN_V0_1"
        return None

    def execute(self, task):
        if task["action"] == "HEALTH_CHECK":
            return {"ok":True,"kind":"HEALTH_CHECK","worker_version":VERSION}
        tests = task.get("payload",{}).get("tests", ["tools/test_nexia_execution_router.py","tools/test_nexia_integrity_check.py"])
        if not isinstance(tests, list) or not tests: raise ValueError("tests must be non-empty list")
        results=[]
        for rel in tests:
            rel=str(rel)
            if not rel.startswith("tools/test_") or not rel.endswith(".py") or ".." in rel: raise ValueError("test path not allowlisted")
            p=subprocess.run([sys.executable, rel], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=120)
            results.append({"test":rel,"returncode":p.returncode,"output_tail":p.stdout[-2000:]})
            if p.returncode: return {"ok":False,"kind":task["action"],"tests":results}
        return {"ok":True,"kind":task["action"],"tests":results}

    def process(self, task):
        tid=str(task.get("task_id","UNKNOWN"))
        if self.stopped():
            self.heartbeat("STOPPED", tid); return self.status(state="STOPPED",task_id=tid,result="NOT_EXECUTED",reason="STOP_LATCHED")
        problem=self.validate(task)
        if problem:
            self.heartbeat("HUMAN_GATE",tid); return self.status(state="HUMAN_GATE",task_id=tid,result="NOT_EXECUTED",reason=problem)
        fp=fingerprint(task); ledger=load(self.ledger_file,{"schema_version":1,"completed":{}}); done=ledger.setdefault("completed",{})
        old=done.get(tid)
        if old and old.get("fingerprint")==fp and old.get("status")=="PASS":
            self.heartbeat("IDLE",tid); return self.status(state="IDLE",task_id=tid,result="SKIPPED_DUPLICATE",fingerprint=fp)
        self.heartbeat("RUNNING",tid); self.status(state="RUNNING",task_id=tid,result=None,fingerprint=fp)
        try:
            outcome=self.execute(task); result="PASS" if outcome.get("ok") else "FAIL"
        except Exception as e:
            outcome={"ok":False,"error_type":type(e).__name__,"error":str(e)}; result="FAIL"
        done[tid]={"fingerprint":fp,"status":result,"completed_at":now()}; write(self.ledger_file,ledger)
        self.heartbeat("IDLE"); return self.status(state="IDLE",task_id=tid,result=result,fingerprint=fp,outcome=outcome)

    def once(self):
        if self.stopped():
            self.heartbeat("STOPPED"); return self.status(state="STOPPED",task_id=None,result="NOT_EXECUTED",reason="STOP_LATCHED")
        queue=load(self.queue_file,{"tasks":[]}); tasks=queue.get("tasks",[])
        if not isinstance(tasks,list): return self.status(state="ERROR",task_id=None,result="FAIL",reason="QUEUE_TASKS_NOT_LIST")
        for task in tasks:
            if str(task.get("status","PENDING")).upper() in {"PENDING","READY"}: return self.process(task)
        self.heartbeat("IDLE"); return self.status(state="IDLE",task_id=None,result="NO_TASK")

def norm(v):
    v=os.path.expandvars(v)
    return Path(".nexia-worker") if (os.name!="nt" and "%" in v) else Path(v)

def main():
    p=argparse.ArgumentParser(); p.add_argument("--state-dir",default=r"%LOCALAPPDATA%\NEXIA\worker"); p.add_argument("--queue-file",default="NEXIA_LOCAL_WORKER_QUEUE.json"); p.add_argument("--control-file",default="NEXIA_LOCAL_WORKER_CONTROL.json"); p.add_argument("--status-file",default=r"%LOCALAPPDATA%\NEXIA\worker\status.json"); p.add_argument("--once",action="store_true"); p.add_argument("--loop",action="store_true"); p.add_argument("--poll-seconds",type=int,default=300); p.add_argument("--rearm-local",action="store_true"); a=p.parse_args()
    w=Worker(norm(a.state_dir),Path(a.queue_file),Path(a.control_file),norm(a.status_file))
    if a.rearm_local: w.rearm_local(); print("LOCAL_REARM: PASS"); return 0
    if a.loop:
        if a.poll_seconds<60: print("poll-seconds must be >=60",file=sys.stderr); return 2
        while True:
            out=w.once(); print(canon(out),flush=True)
            if out.get("state")=="STOPPED": return 0
            time.sleep(a.poll_seconds)
    out=w.once(); print(canon(out)); return 1 if out.get("result")=="FAIL" else 0
if __name__=="__main__": raise SystemExit(main())
