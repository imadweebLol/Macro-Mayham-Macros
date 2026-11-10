# Macro Mayham — Official Macros

Official macro catalog for **Mayham Accounts**.

## Published

- **PS99 — Halloween Event Part 4** (`macros/AutoHotkey/HalloweenEventPart4-PS99.ahk`)
  - Requires **AutoHotkey v2**
  - Controls in the script: **F1** start, **F2** menu, **F3** stop/exit, **F4** diagnostics
  - The script automates Roblox game actions. Run only after inspecting the script, understanding the actions, and reviewing the game's rules.

## Publish to GitHub

1. Create a public repository named `Macro-Mayham-Macros`.
2. Upload **the contents of this ZIP**, not the outer folder, to the repository root.
3. Commit the files to the default branch (`main` recommended).
4. In the updated Mayham Accounts Macros tab, paste the URL of your public repository and select **Connect / Refresh**.
5. Players with this updated Mayham Accounts version can retrieve future catalog changes without rebuilding the app.

## Updates

To publish another macro, add its file under `macros/`, add a metadata entry to `catalog.json` with the relative path and **SHA-256** of the uploaded file, then commit. The app displays the catalog but never runs downloaded macros automatically. GitHub hosts the downloads; no personal server needed.

## Security

AutoHotkey scripts execute desktop automation and can access local files/processes. Only publish scripts you trust. The catalog SHA-256 lets users check they received the published file; it does not mean the script is inherently safe.
