# RUL3S Agent Notes

This directory contains the local Chrome extension that gets loaded during the launch flow.

## Launch wiring
- The **Launch** action in `C0MMON/Actions/Launch.cs` loads the extension directly from `./RUL3S`.
- The launch flow also uploads a rules file named `resource_override_rules.json` from `./RUL3S`.
- When updating the extension or rules workflow, keep the folder name `RUL3S` stable so the automation can keep pointing at the same path.

## Rules file handling
- The rules file is expected to be a JSON export created by the Resource Override extension UI.
- Place the exported `resource_override_rules.json` in this folder so the launch automation can find it.
- If the rules file name changes, update the launch action path and document the new name here.

## Maintenance notes
- Keep any UI/pixel assumptions about the Chrome extension import flow in the Launch action code.
- If the extension structure changes (manifest location, required assets, etc.), update the launch notes and paths together.
