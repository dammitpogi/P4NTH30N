description:
  Remove files from the working tree and from the index
synopses:
  - git rm [-f | --force] [-n] [-r] [--cached] [--ignore-unmatch]
    [--quiet] [--pathspec-from-file=<file> [--pathspec-file-nul]]
    [--] [<pathspec>…​]
options:
  -f, --force: Override the up-to-date check.
  -n, --dry-run: Don't actually remove any file(s). Instead, just show if they exist in the index and would otherwise be removed by the command.
  -r: Allow recursive removal when a leading directory name is given.
  --cached: Use this option to unstage and remove paths only from the index.
  --ignore-unmatch: Exit with a zero status even if no files matched.
  --sparse: Allow updating index entries outside of the sparse-checkout cone.
  -q, --quiet: git rm normally outputs one line (in the form of an rm command) for each file removed. This option suppresses that output.
  --pathspec-from-file=<file>: Pathspec is passed in <file> instead of commandline args.
  --pathspec-file-nul: Pathspec elements are separated with NUL character and all other characters are taken literally.