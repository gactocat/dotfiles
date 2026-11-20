---
name: html-share
description: Share an HTML file with people inside the company by uploading it to the user's Google Drive folder that a Google Apps Script web app serves, and return the viewer URL (`<web app URL>?id=<Drive file ID>`). Also updates an already shared HTML in place so its URL stays the same, finds the URL of an HTML shared earlier, and checks who can open it. Works for local HTML files and for HTML taken from an Artifact. Use it for requests such as 「HTML を共有して」「このレポートを社内に共有できる URL にして」「この HTML を GAS で見られるようにして」「Drive に上げて共有リンクをちょうだい」「共有済みの HTML を差し替えて」「前に共有した HTML の URL は」, even when Drive or Apps Script is not named.
---

# HTML share

The user keeps a Drive folder of HTML files and an Apps Script web app that renders them. Anyone signed in with a Google account of the user's Workspace domain can open `<webapp_url>?id=<file ID>`; people outside the domain, or not signed in, get the Google sign-in page and cannot see it. The script does the upload and the checks; you choose the file and the name, handle name conflicts, and give the user the URL.

## How the viewer works

Knowing this tells you what to re-check if sharing stops working.

- The web app runs as the user who deployed it (`executeAs: USER_DEPLOYING`) with access `DOMAIN`, so it reads the files with the owner's rights. The files and the folder stay private on Drive; never change their sharing to make a page viewable.
- `?id=<file ID>` renders that file's content as is (read as UTF-8, through `HtmlService`, inside Google's sandboxed iframe). The browser tab title is the Drive file name without `.html`, not the page's `<title>`, so pick a readable name.
- `?file=<name>` also works, but it returns the first match by name, so it breaks when names repeat or change. Always share the `?id=` form.
- The web app URL without parameters is an index that lists every HTML in the folder (and its direct subfolders) to anyone in the domain. Anything uploaded is therefore findable by the whole domain, not only by the people who get the link.
- Uploading, renaming and deleting through the index page are limited to the owner. This skill uses the Drive API directly instead.

## Inputs

- **Config**: `~/.local/state/html-share/config.json` with `google_account`, `folder_id`, `webapp_url` and `script_file_id` (the Apps Script project, used only by `check`). `references/config.example.json` shows the shape. The repo is public, so never copy these values into this skill. If the file is missing, ask the user for the folder URL and the web app URL and create it.
- **HTML**: a local file, or a page from an Artifact (see below).
- **Audience**: who will open it. If the user names someone outside the company, say they cannot open it and stop before uploading.

## Steps

Set `S=~/.claude/skills/html-share/scripts`.

1. **Prepare the file.**
   - The file must be UTF-8. A full document (`<!doctype html>`, `<meta charset="utf-8">`, viewport meta) renders most reliably.
   - From an Artifact: read it with the Artifact tool (`action: "read"`), which saves the page to a local file. Artifact pages are often a body fragment; wrap them in a full document with a `<title>` and the metas above. Anything that relies on `window.claude.*` (runtime capabilities) does not work outside claude.ai; tell the user which parts will be dead.
   - Content is visible to the whole domain through the index page. If the page holds personal data or anything meant for a few people only, warn the user and get a go-ahead before uploading.
2. **Choose the name.** The Drive name becomes the tab title and the entry on the index. Use the title the user would recognize, in Japanese if the page is Japanese, ending in `.html`. Pass it with `--name` when the local file name is not that.
3. **Upload**: `python3 $S/share_html.py upload <path> --name "<name>"`. It uploads into the folder, then checks that the Drive size equals the local size, that the file is in the folder and that its type is `text/html`, and prints `url`. Exit codes:
   - `0`: done. Give the user `url`.
   - `3`: a file with that name already exists; the output lists it with its URL and modified time. Decide with the rule in "Same name" below and rerun with `--on-conflict replace` or `--on-conflict new`.
   - `2`: gcloud has no valid token with the Drive scope for `google_account`. See "Authentication".
   - `1`: an API error or a failed check; report the output as is. Do not retry in a loop.
4. **Hand over** the URL with one line on who can open it: people in the company signed in with their company Google account; not people outside it. If the user wants it posted somewhere, draft the message and let the user send it.

### Same name

Overwriting keeps the file ID, so the URL already shared keeps working and shows the new content. Drive keeps the previous content as an older version for 30 days, so it can be restored from the file's version history.

- The file is a newer version of the same document (the user says 更新 / 差し替え / 最新にして, or the page is a regenerated report with the same title): `--on-conflict replace`.
- A different document that happens to have the same name: `--on-conflict new`, which uploads as `<name> (2).html` (or the next free number).
- Not clear which: ask the user, showing the existing file's URL and modified time.
- Several files already share the name: `replace` stops with exit 3 and lists them. Ask which one, then rerun with `--file-id <id>`.

When the user gives the URL or file ID to update, use `upload <path> --file-id <id>` directly. It refuses files outside the folder.

### Authentication

The script uses `gcloud auth print-access-token --account=<google_account>`. When it exits 2:

1. Run `gcloud config get account` and remember the result.
2. Ask the user to run `! gcloud auth login <google_account> --enable-gdrive-access`. This also makes that account gcloud's active account; afterwards switch back with `gcloud config set account <remembered account>` if it was a different one, and tell the user.
3. Rerun the upload.

The company may require signing in again every so often, so exit 2 can come back on a later day; the same steps fix it.

If the user does not want to sign in now, a **new** file of up to about 50 KB can go through the Google Drive connector instead:

1. `search_files` with `parentId = '<folder_id>' and title = '<name>'`. If anything matches, stop: the connector cannot overwrite content, so name conflicts need the script.
2. Read the file, then `create_file` with `title` = the name, `parentId` = `folder_id`, `contentMimeType` = `text/html`, `disableConversionToGoogleType` = true and `textContent` = the file's content exactly.
3. Compare the returned `fileSize` with `wc -c < <path>`. If they differ, trash the new file with `trash_file` and tell the user.
4. The URL is `<webapp_url>?id=<returned id>`.

Larger files do not survive being written inline, so they need the script.

## Other tasks

- **Find an earlier share**: `python3 $S/share_html.py find [text]` lists the HTML files in the folder whose name contains the text, newest first, with their URLs.
- **Check who can open it**: `python3 $S/share_html.py check [--file-id <id>]` prints the folder's permissions, the web app's `executeAs` and `access` from the Apps Script manifest, and, for a file, whether it is in the folder and its own permissions. Expect `USER_DEPLOYING` and `DOMAIN`, a folder shared with nobody else, and files with only the owner. The manifest is the project's current source, which a deployment pinned to an old version may not match; if the result and what people see disagree, ask the user to check the deployment in the Apps Script editor. If the export fails, the connector's `download_file_content` with `exportMimeType` = `application/vnd.google-apps.script+json` returns the same project as base64.
- **Remove a share**: confirm with the user first, then `trash_file` with the Google Drive connector. The URL stops working at once; the file stays in the owner's trash for 30 days.

## Viewer quirks

- Links inside the page open within Google's iframe, and many sites refuse to be shown there. Give external links `target="_blank"`, or add `<base target="_blank">` to the head.
- Very large pages (several MB) load slowly through the web app. Open the URL once yourself or ask the user to before sharing a big file.
- People signed in to several Google accounts sometimes get an error page because the browser picks a personal account first. Opening the link in a window signed in only to the company account fixes it.

## Do not

- Do not change the Apps Script code, its deployment or the sharing of the folder or files. Suggest changes to the user instead.
- Do not write tokens, the folder ID or the web app URL into this skill or into any file in the repo.
