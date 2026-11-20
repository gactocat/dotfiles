#!/usr/bin/env python3
"""Upload HTML to the Drive folder behind the GAS viewer and print the share URL.

Subcommands:
  upload PATH [--name NAME] [--on-conflict fail|replace|new] [--file-id ID]
  find [TEXT]            list HTML files in the folder whose name contains TEXT
  check [--file-id ID]   show the folder's sharing, the web app's access setting
                         and, with --file-id, whether that file is in the folder

The config (default ~/.local/state/html-share/config.json) holds google_account,
folder_id, webapp_url and script_file_id. The token comes from gcloud for
google_account and needs the Drive scope.

Exit codes: 0 ok, 1 API error or failed verification, 2 no valid gcloud token
with the Drive scope, 3 a file with the same name exists (upload without
--on-conflict replace|new) or the name matches several files.
"""
import argparse
import json
import os
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request
import uuid

API = "https://www.googleapis.com"
DRIVE_SCOPE = "https://www.googleapis.com/auth/drive"
DEFAULT_CONFIG = os.path.expanduser("~/.local/state/html-share/config.json")
FIELDS = "id,name,size,parents,mimeType,modifiedTime,trashed"


class ApiError(Exception):
    pass


def load_config(path):
    with open(path) as f:
        cfg = json.load(f)
    missing = [k for k in ("google_account", "folder_id", "webapp_url") if not cfg.get(k)]
    if missing:
        sys.exit(f"config {path} is missing: {', '.join(missing)}")
    return cfg


def token(account):
    r = subprocess.run(["gcloud", "auth", "print-access-token", f"--account={account}"],
                       capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stderr.strip().splitlines()[0] if r.stderr.strip() else "gcloud failed", file=sys.stderr)
        sys.exit(2)
    tok = r.stdout.strip()
    try:
        with urllib.request.urlopen(f"{API}/oauth2/v3/tokeninfo?access_token={tok}") as res:
            scopes = json.load(res).get("scope", "").split()
    except urllib.error.HTTPError:
        sys.exit(2)
    if DRIVE_SCOPE not in scopes:
        print("token has no Drive scope", file=sys.stderr)
        sys.exit(2)
    return tok


def call(tok, method, path, params=None, body=None, ctype=None, raw=False):
    url = f"{API}{path}"
    if params:
        url += "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, data=body, method=method, headers={"Authorization": f"Bearer {tok}"})
    if ctype:
        req.add_header("Content-Type", ctype)
    try:
        with urllib.request.urlopen(req) as res:
            data = res.read()
    except urllib.error.HTTPError as e:
        raise ApiError(f"{method} {path} failed: {e.code} {e.read().decode(errors='replace')[:300]}")
    return data if raw else json.loads(data or b"{}")


def q_str(s):
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'") + "'"


def html_name(name):
    name = name.strip()
    return name if name.lower().endswith((".html", ".htm")) else name + ".html"


def viewer_url(cfg, file_id):
    return f"{cfg['webapp_url']}?id={urllib.parse.quote(file_id)}"


def list_folder(tok, folder_id, name=None, contains=None):
    q = [f"{q_str(folder_id)} in parents", "trashed = false"]
    if name is not None:
        q.append(f"name = {q_str(name)}")
    if contains:
        q.append(f"name contains {q_str(contains)}")
    files, page = [], None
    while True:
        params = {"q": " and ".join(q), "fields": f"nextPageToken,files({FIELDS})",
                  "pageSize": 200, "supportsAllDrives": "true", "includeItemsFromAllDrives": "true"}
        if page:
            params["pageToken"] = page
        res = call(tok, "GET", "/drive/v3/files", params)
        files += res.get("files", [])
        page = res.get("nextPageToken")
        if not page:
            return files


def get_meta(tok, file_id):
    return call(tok, "GET", f"/drive/v3/files/{file_id}", {"fields": FIELDS, "supportsAllDrives": "true"})


def free_name(tok, folder_id, name):
    stem, ext = os.path.splitext(name)
    taken = {f["name"] for f in list_folder(tok, folder_id, contains=stem)}
    n = 2
    while f"{stem} ({n}){ext}" in taken:
        n += 1
    return f"{stem} ({n}){ext}"


def create(tok, folder_id, name, body):
    boundary = uuid.uuid4().hex
    meta = json.dumps({"name": name, "parents": [folder_id], "mimeType": "text/html"}).encode()
    payload = b"".join([
        f"--{boundary}\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n".encode(), meta,
        f"\r\n--{boundary}\r\nContent-Type: text/html; charset=UTF-8\r\n\r\n".encode(), body,
        f"\r\n--{boundary}--\r\n".encode(),
    ])
    return call(tok, "POST", "/upload/drive/v3/files",
                {"uploadType": "multipart", "fields": FIELDS, "supportsAllDrives": "true"},
                payload, f"multipart/related; boundary={boundary}")


def replace(tok, file_id, body):
    return call(tok, "PATCH", f"/upload/drive/v3/files/{file_id}",
                {"uploadType": "media", "fields": FIELDS, "supportsAllDrives": "true"},
                body, "text/html; charset=UTF-8")


def cmd_upload(cfg, tok, a):
    with open(a.path, "rb") as f:
        body = f.read()
    try:
        body.decode("utf-8")
    except UnicodeDecodeError:
        sys.exit("the file is not UTF-8; the viewer reads files as UTF-8, so convert it first")
    folder = cfg["folder_id"]
    name = html_name(a.name or os.path.basename(a.path))

    before = None
    if a.file_id:
        before = get_meta(tok, a.file_id)
        if folder not in before.get("parents", []):
            sys.exit(f"{a.file_id} is not in the share folder; refusing to overwrite it")
        target, action = a.file_id, "replaced"
    else:
        same = list_folder(tok, folder, name=name)
        if same and a.on_conflict == "fail":
            print(json.dumps({"conflict": name, "existing": [
                {**f, "url": viewer_url(cfg, f["id"])} for f in same]}, ensure_ascii=False, indent=1))
            sys.exit(3)
        if same and a.on_conflict == "replace":
            if len(same) > 1:
                print(json.dumps({"ambiguous": name, "existing": [
                    {**f, "url": viewer_url(cfg, f["id"])} for f in same]}, ensure_ascii=False, indent=1))
                sys.exit(3)
            before = same[0]
            target, action = before["id"], "replaced"
        else:
            if same:
                name = free_name(tok, folder, name)
            target, action = None, "created"

    meta = replace(tok, target, body) if target else create(tok, folder, name, body)
    after = get_meta(tok, meta["id"])
    checks = {
        "size_matches": int(after.get("size", -1)) == len(body),
        "in_folder": folder in after.get("parents", []),
        "html_mime": after.get("mimeType") == "text/html",
    }
    if before:
        checks["modified_moved"] = after["modifiedTime"] > before["modifiedTime"]
    ok = all(checks.values())
    print(json.dumps({
        "ok": ok, "action": action, "id": after["id"], "name": after["name"],
        "url": viewer_url(cfg, after["id"]),
        "drive_url": f"https://drive.google.com/file/d/{after['id']}/view",
        "local_size": len(body), "drive_size": int(after.get("size", -1)), "checks": checks,
    }, ensure_ascii=False, indent=1))
    sys.exit(0 if ok else 1)


def cmd_find(cfg, tok, a):
    files = list_folder(tok, cfg["folder_id"], contains=a.text or None)
    files.sort(key=lambda f: f["modifiedTime"], reverse=True)
    print(json.dumps([{"name": f["name"], "id": f["id"], "modified": f["modifiedTime"],
                       "size": f.get("size"), "url": viewer_url(cfg, f["id"])} for f in files],
                     ensure_ascii=False, indent=1))


def cmd_check(cfg, tok, a):
    out = {}
    perms = call(tok, "GET", f"/drive/v3/files/{cfg['folder_id']}/permissions",
                 {"fields": "permissions(type,role,emailAddress,domain)", "supportsAllDrives": "true"})
    out["folder_permissions"] = perms.get("permissions", [])
    if cfg.get("script_file_id"):
        try:
            raw = call(tok, "GET", f"/drive/v3/files/{cfg['script_file_id']}/export",
                       {"mimeType": "application/vnd.google-apps.script+json"}, raw=True)
            manifest = next(f for f in json.loads(raw)["files"] if f["name"] == "appsscript")
            out["webapp"] = json.loads(manifest["source"]).get("webapp")
        except (ApiError, StopIteration, KeyError, ValueError) as e:
            out["webapp_error"] = str(e)
    if a.file_id:
        meta = get_meta(tok, a.file_id)
        fp = call(tok, "GET", f"/drive/v3/files/{a.file_id}/permissions",
                  {"fields": "permissions(type,role,emailAddress,domain)", "supportsAllDrives": "true"})
        out["file"] = {**meta, "in_folder": cfg["folder_id"] in meta.get("parents", []),
                       "permissions": fp.get("permissions", []), "url": viewer_url(cfg, a.file_id)}
    print(json.dumps(out, ensure_ascii=False, indent=1))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--config", default=DEFAULT_CONFIG)
    sub = ap.add_subparsers(dest="cmd", required=True)
    up = sub.add_parser("upload")
    up.add_argument("path")
    up.add_argument("--name", help="file name on Drive (default: the local file name)")
    up.add_argument("--on-conflict", choices=["fail", "replace", "new"], default="fail")
    up.add_argument("--file-id", help="overwrite this file in the folder instead of matching by name")
    fd = sub.add_parser("find")
    fd.add_argument("text", nargs="?")
    ck = sub.add_parser("check")
    ck.add_argument("--file-id")
    a = ap.parse_args()

    cfg = load_config(a.config)
    tok = token(cfg["google_account"])
    try:
        {"upload": cmd_upload, "find": cmd_find, "check": cmd_check}[a.cmd](cfg, tok, a)
    except ApiError as e:
        sys.exit(str(e))


if __name__ == "__main__":
    main()
