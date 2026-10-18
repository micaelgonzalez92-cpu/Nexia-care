#!/usr/bin/env python3
"""Fail-closed recovery guard for Nexia session/task preflight.

Only verifies repository byte bindings and supplied session evidence structure.
It cannot authenticate external services or install itself in ChatGPT Project UI.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path

_SHA = re.compile(r"^[a-f0-9]{40}$")


def blob_sha(data):
    return hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()


def run(root, require_connector=(), session_manifest=None):
    root = Path(root).resolve()
    errors = []
    observed = {}

    def load(path, expected=None):
        p = (root / path).resolve()
        if not p.is_relative_to(root) or not p.is_file():
            errors.append("MISSING_OR_UNSAFE_FILE:" + str(path))
            return None
        try:
            data = p.read_bytes()
            digest = blob_sha(data)
            observed[path] = digest
            if expected is not None and (not isinstance(expected, str) or not _SHA.fullmatch(expected) or digest != expected):
                errors.append("BLOB_SHA_MISMATCH:" + str(path))
            value = json.loads(data)
            if not isinstance(value, dict):
                raise ValueError("JSON root is not an object")
            return value
        except (OSError, ValueError, UnicodeError):
            errors.append("INVALID_JSON:" + str(path))
            return None

    boot = load("NEXIA_BOOT.json")
    if boot is None:
        return {"status": "BLOCKED", "errors": errors, "observed": observed}
    state = load("NEXIA_STATE.json", boot.get("state_blob_sha"))
    live = load("NEXIA_LIVE.json", boot.get("live_state_blob_sha"))
    storage = boot.get("event_storage")
    if not isinstance(storage, dict):
        errors.append("BOOT_EVENT_STORAGE_MISSING")
        storage = {}
    active = storage.get("active_index")
    if not isinstance(active, str) or not re.fullmatch(r"NEXIA_EVENT_INDEX_V\d+\.json", active):
        errors.append("INVALID_ACTIVE_INDEX")
        index = None
    else:
        index = load(active, storage.get("active_index_blob_sha"))
    if state is not None and (state.get("version") != boot.get("state_version") or not isinstance(state.get("version"), int)):
        errors.append("BOOT_STATE_VERSION_MISMATCH")
    if live is not None:
        if live.get("state_version") != boot.get("state_version") or live.get("state_blob_sha") != boot.get("state_blob_sha"):
            errors.append("LIVE_STATE_BINDING_MISMATCH")
        ls = live.get("event_storage")
        if not isinstance(ls, dict) or ls.get("active_index") != active or ls.get("active_index_blob_sha") != storage.get("active_index_blob_sha"):
            errors.append("LIVE_INDEX_BINDING_MISMATCH")
    if index is not None:
        if index.get("canonical_state_version") != boot.get("state_version") or index.get("canonical_state_blob_sha") != boot.get("state_blob_sha"):
            errors.append("INDEX_STATE_BINDING_MISMATCH")
        latest_path = storage.get("latest_verified_event_path")
        latest_sha = storage.get("latest_verified_event_blob_sha")
        if not isinstance(latest_path, str) or not latest_path.startswith("events/") or not latest_path.endswith(".json"):
            errors.append("INVALID_LATEST_EVENT_PATH")
        else:
            event = load(latest_path, latest_sha)
            if event is not None and event.get("event_id") != storage.get("latest_verified_event_id"):
                errors.append("LATEST_EVENT_ID_MISMATCH")
            if index.get("latest_event_path") != latest_path or index.get("latest_event_blob_sha") != latest_sha:
                errors.append("INDEX_LATEST_EVENT_MISMATCH")
    connectors = sorted(set(require_connector))
    if connectors:
        manifest = None
        if not session_manifest:
            errors.append("NO_SESSION_CONNECTOR_ATTESTATION")
        else:
            try:
                manifest = json.loads(Path(session_manifest).read_text(encoding="utf-8"))
                if not isinstance(manifest, dict):
                    raise ValueError("not an object")
            except (OSError, ValueError, UnicodeError):
                errors.append("INVALID_SESSION_CONNECTOR_ATTESTATION")
        if manifest is not None:
            if manifest.get("project") != "NEXIA CORE":
                errors.append("ATTESTATION_PROJECT_MISMATCH")
            for name in connectors:
                evidence = manifest.get("connectors", {}).get(name, {}) if isinstance(manifest.get("connectors"), dict) else {}
                if not isinstance(evidence, dict) or evidence.get("verified_in_this_session") is not True or evidence.get("approved_for_nexia") is not True or not evidence.get("verification_reference"):
                    errors.append("CONNECTOR_NOT_VERIFIED_FOR_NEXIA:" + name)
    return {"status": "BLOCKED" if errors else "PASS_REPOSITORY_BINDINGS_ONLY", "errors": errors, "observed": observed, "required_connectors": connectors, "limitations": ["Does not attest API availability or current login", "Does not prove external connector assertions", "Does not replace full-chain integrity/CI or GitHub remote readback"]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".")
    ap.add_argument("--require-connector", action="append", default=[])
    ap.add_argument("--session-manifest")
    args = ap.parse_args()
    result = run(args.root, args.require_connector, args.session_manifest)
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0 if result["status"] == "PASS_REPOSITORY_BINDINGS_ONLY" else 1


if __name__ == "__main__":
    raise SystemExit(main())
