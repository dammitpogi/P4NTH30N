description:
  Add file contents to the index
synopses:
  - git add [--verbose | -v] [--dry-run | -n] [--force | -f] [--interactive | -i] [--patch | -p]
    [--edit | -e] [--all | --no-all | --ignore-removal | --no-ignore-removal | [--update | -u]] [--sparse]
    [--intent-to-add | -N] [--refresh] [--ignore-errors] [--ignore-missing] [--renormalize]
    [--chmod=(+|-)x] [--pathspec-from-file=<file> [--pathspec-file-nul]]
    [--] [<pathspec>…​]
options:
  -n, --dry-run: Don't actually add the file(s), just show if they exist and/or will be ignored.
  -v, --verbose: Be verbose.
  -f, --force: Allow adding otherwise ignored files.
  --sparse: Allow updating index entries outside of the sparse-checkout cone.
  -i, --interactive: Add modified contents in the working tree interactively to the index.
  -p, --patch: Interactively choose hunks of patch between the index and the work tree and add them to the index.
  -e, --edit: Open the diff vs. the index in an editor and let the user edit it. After the editor was closed, adjust the hunk headers and apply the patch to the index.
  -u, --update: Update the index just where it already has an entry matching <pathspec>.
  -A, --all, --no-ignore-removal: Update the index not only where the working tree has a file matching <pathspec> but also where the index already has an entry. This adds, modifies, and removes index entries to match the working tree.
  --no-all, --ignore-removal: Update the index by adding new files that are unknown to the index and files modified in the working tree, but ignore files that have been removed from the working tree.
  -N, --intent-to-add: Record only the fact that the path will be added later.
  --refresh: Don't add the file(s), but only refresh their stat() information in the index.
  --ignore-errors: If some files could not be added because of errors indexing them, do not abort the operation, but continue adding the others.
  --ignore-missing: This option can only be used together with --dry-run. By using this option the user can check if any of the given files would be ignored, no matter if they are already present in the work tree or not.
  --no-warn-embedded-repo: By default, git add will warn when adding an embedded repository to the index without using git submodule add to create an entry in .gitmodules. This option will suppress the warning.
  --renormalize: Apply the "clean" process freshly to all tracked files to forcibly add them again to the index. This option implies -u.
  --chmod=(+|-)x: Override the executable bit of the added files.
  --pathspec-from-file=<file>: Pathspec is passed in <file> instead of commandline args.
  --pathspec-file-nul: Only meaningful with --pathspec-from-file. Pathspec elements are separated with NUL character and all other characters are taken literally (including newlines and quotes).