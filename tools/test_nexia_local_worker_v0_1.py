import tempfile, unittest
from pathlib import Path
import nexia_local_worker_v0_1 as w

class WorkerTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory(); root=Path(self.tmp.name)
        self.worker=w.Worker(root/'state', root/'queue.json', root/'control.json', root/'status.json')
        w.write(root/'control.json', {'desired_state':'RUN'})
    def tearDown(self): self.tmp.cleanup()
    def task(self, **kw):
        t={'task_id':'T-001','action':'HEALTH_CHECK','authority':'GREEN_INTERNAL','status':'READY','payload':{},'external_effects':[]}; t.update(kw); return t
    def test_green_health_passes(self): self.assertEqual(self.worker.process(self.task())['result'],'PASS')
    def test_red_goes_human_gate(self): self.assertEqual(self.worker.process(self.task(authority='RED'))['state'],'HUMAN_GATE')
    def test_unknown_action_goes_human_gate(self): self.assertEqual(self.worker.process(self.task(action='DELETE_EVERYTHING'))['state'],'HUMAN_GATE')
    def test_external_effects_forbidden(self): self.assertEqual(self.worker.process(self.task(external_effects=['SEND']))['state'],'HUMAN_GATE')
    def test_duplicate_pass_is_skipped(self):
        self.assertEqual(self.worker.process(self.task())['result'],'PASS'); self.assertEqual(self.worker.process(self.task())['result'],'SKIPPED_DUPLICATE')
    def test_remote_stop_latches_and_remote_run_does_not_clear(self):
        w.write(self.worker.control_file, {'desired_state':'STOP','reason':'TEST'}); self.assertEqual(self.worker.process(self.task())['state'],'STOPPED')
        w.write(self.worker.control_file, {'desired_state':'RUN'}); self.assertEqual(self.worker.process(self.task(task_id='T-002'))['state'],'STOPPED')
    def test_local_rearm_clears_latch(self):
        w.write(self.worker.control_file, {'desired_state':'STOP'}); self.worker.process(self.task()); w.write(self.worker.control_file, {'desired_state':'RUN'}); self.worker.rearm_local()
        self.assertEqual(self.worker.process(self.task(task_id='T-002'))['result'],'PASS')
    def test_queue_processes_first_ready_only(self):
        w.write(self.worker.queue_file, {'tasks':[self.task(task_id='A',status='DONE'),self.task(task_id='B'),self.task(task_id='C')]})
        self.assertEqual(self.worker.once()['task_id'],'B')
    def test_no_task_idle(self):
        w.write(self.worker.queue_file, {'tasks':[]}); out=self.worker.once(); self.assertEqual((out['state'],out['result']),('IDLE','NO_TASK'))
    def test_manager_does_not_reassign_validated_action_parameter(self):
        text=Path('tools/manage_nexia_local_worker_v0_1.ps1').read_text(encoding='utf-8')
        assignments=[line.strip().lower() for line in text.splitlines() if line.strip().lower().startswith('$action=')]
        self.assertEqual(assignments, [])
    def test_manager_separates_pinned_code_from_dynamic_control_branch(self):
        text=Path('tools/manage_nexia_local_worker_v0_1.ps1').read_text(encoding='utf-8')
        self.assertIn("[string]$ControlBranch='main'", text)
        self.assertIn('function RawCode', text)
        self.assertIn('function RawControl', text)
        self.assertIn('-Branch `"$ControlBranch`"', text)
        self.assertIn("RawControl 'NEXIA_LOCAL_WORKER_CONTROL.json'", text)

if __name__=='__main__': unittest.main()
