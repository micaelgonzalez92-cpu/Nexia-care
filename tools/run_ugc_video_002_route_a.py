from __future__ import annotations
import argparse, json, shutil, subprocess, tempfile, time
from pathlib import Path

A1 = "NEXIA_BENCHMARK_00002_.png"
A2 = "NEXIA_BENCHMARK_00003_.png"
DEFAULT_OUT = "NEXIA_UGC_VIDEO_002_ROUTE_A_SPEC.mp4"

SRT = """1
00:00:00,000 --> 00:00:02,500
¿Necesitas más espacio?

2
00:00:02,500 --> 00:00:06,000
O quizá... mejor orden.

3
00:00:06,000 --> 00:00:11,000
De caos a visible y accesible.

4
00:00:11,000 --> 00:00:16,000
Verlo. Cogerlo. Guardarlo.

5
00:00:16,000 --> 00:00:20,500
Mismo espacio. Menos caos.

6
00:00:20,500 --> 00:00:24,000
Empieza por un solo rincón.
CLEARNEST — SPEC CONCEPT
"""

SHOTS = [
    (A1, 2.5, "push"), (A1, 3.5, "pan_left"),
    (A1, 2.5, "push"), (A2, 2.5, "push"),
    (A2, 5.0, "pan_right"),
    (A1, 2.25, "push"), (A2, 2.25, "push"),
    (A2, 3.5, "push"),
]

def run(cmd, cwd=None):
    return subprocess.run(cmd, cwd=cwd, text=True, capture_output=True, check=False)

def need(name):
    p = shutil.which(name)
    if not p:
        raise RuntimeError(f"{name.upper()}_NOT_AVAILABLE; no installation attempted.")
    return p

def find_output(explicit=None):
    if explicit:
        p = Path(explicit).expanduser().resolve()
        if p.is_dir():
            return p
        raise RuntimeError(f"COMFY_OUTPUT_NOT_FOUND: {p}")
    home = Path.home()
    candidates = list(home.glob(
        ".codex/.chatgpt-projects/*/outputs/creative-benchmark-2026-10-12/"
        "ComfyUI_windows_portable/ComfyUI/output"
    ))
    candidates += [
        home/"ComfyUI_windows_portable"/"ComfyUI"/"output",
        home/"ComfyUI"/"output",
    ]
    for p in candidates:
        if p.is_dir():
            return p.resolve()
    raise RuntimeError("COMFY_OUTPUT_NOT_FOUND; use --comfy-output.")

def vf(mode, frames):
    pre = "scale=1200:2134:force_original_aspect_ratio=increase,crop=1200:2134"
    if mode == "pan_left":
        z = "zoompan=z='1.06':x='(iw-iw/zoom)*(1-on/(d-1))':y='(ih-ih/zoom)/2'"
    elif mode == "pan_right":
        z = "zoompan=z='1.06':x='(iw-iw/zoom)*(on/(d-1))':y='(ih-ih/zoom)/2'"
    else:
        z = "zoompan=z='min(1+on*0.0008,1.08)':x='(iw-iw/zoom)/2':y='(ih-ih/zoom)/2'"
    return f"{pre},{z}:d={frames}:s=1080x1920:fps=30,format=yuv420p"

def render(ffmpeg, src, duration, mode, out):
    frames = max(1, round(duration*30))
    p = run([
        ffmpeg, "-y", "-loop", "1", "-i", str(src),
        "-vf", vf(mode, frames), "-t", f"{duration:.3f}", "-r", "30", "-an",
        "-c:v", "libx264", "-preset", "medium", "-crf", "18",
        "-pix_fmt", "yuv420p", str(out)
    ])
    if p.returncode or not out.exists():
        raise RuntimeError("FFMPEG_SEGMENT_FAIL: " + p.stderr[-1500:])

def probe(ffprobe, path):
    p = run([ffprobe, "-v", "error", "-show_entries", "format=duration,size", "-of", "json", str(path)])
    if p.returncode:
        return {"error": p.stderr[-500:]}
    return json.loads(p.stdout).get("format", {})

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--comfy-output")
    ap.add_argument("--output", default=DEFAULT_OUT)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    report = {
        "experiment": "UGC-VIDEO-002",
        "route": "A_ANATOMY_MINIMIZED_DETERMINISTIC",
        "cash_spend_eur": 0,
        "cloud_api_used": False,
        "audio": "NONE_CAPTIONED_FIRST_PROOF",
        "professional_qa": "NOT_YET_PERFORMED",
    }
    try:
        ffmpeg, ffprobe = need("ffmpeg"), need("ffprobe")
        source_dir = find_output(args.comfy_output)
        sources = {A1: source_dir/A1, A2: source_dir/A2}
        missing = [k for k,v in sources.items() if not v.exists()]
        if missing:
            raise RuntimeError("MISSING_ACCEPTED_SOURCE_ASSET: " + ", ".join(missing))
        report["source_dir"] = str(source_dir)
        report["ffmpeg"] = ffmpeg
        report["ffprobe"] = ffprobe
        if args.dry_run:
            report["status"] = "DRY_RUN_PASS"
            print(json.dumps(report, ensure_ascii=False, indent=2))
            return 0

        out = Path(args.output).expanduser().resolve()
        out.parent.mkdir(parents=True, exist_ok=True)
        started = time.time()
        with tempfile.TemporaryDirectory(prefix="nexia_ugc002_") as td:
            work = Path(td)
            segs = []
            for i,(name,dur,mode) in enumerate(SHOTS,1):
                seg = work/f"seg_{i:02d}.mp4"
                render(ffmpeg, sources[name], dur, mode, seg)
                segs.append(seg)
            manifest = work/"concat.txt"
            manifest.write_text("\n".join(f"file '{p.name}'" for p in segs), encoding="utf-8")
            base = work/"base.mp4"
            p = run([ffmpeg,"-y","-f","concat","-safe","0","-i",manifest.name,"-c","copy",base.name], cwd=work)
            if p.returncode or not base.exists():
                raise RuntimeError("FFMPEG_CONCAT_FAIL: " + p.stderr[-1500:])
            (work/"captions.srt").write_text(SRT, encoding="utf-8")
            final = work/"final.mp4"
            style = "FontName=Arial,FontSize=18,Outline=2,Shadow=1,Alignment=2,MarginV=120"
            p = run([
                ffmpeg,"-y","-i",base.name,
                "-vf",f"subtitles=captions.srt:force_style='{style}'",
                "-an","-c:v","libx264","-preset","medium","-crf","18","-pix_fmt","yuv420p",final.name
            ], cwd=work)
            if p.returncode or not final.exists():
                raise RuntimeError("FFMPEG_SUBTITLE_FAIL: " + p.stderr[-1500:])
            shutil.copy2(final, out)

        report["status"] = "TECHNICAL_ASSEMBLY_COMPLETE_NOT_PROFESSIONALLY_ADJUDICATED"
        report["wall_seconds"] = round(time.time()-started,2)
        report["output"] = str(out)
        report["probe"] = probe(ffprobe, out)
        out.with_suffix(".report.json").write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding="utf-8")
        print(json.dumps(report,ensure_ascii=False,indent=2))
        return 0
    except Exception as e:
        report["status"] = "FAIL"
        report["error"] = f"{type(e).__name__}: {e}"
        print(json.dumps(report,ensure_ascii=False,indent=2))
        return 2

if __name__ == "__main__":
    raise SystemExit(main())
