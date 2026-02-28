description:
  change file mode bits
synopses:
  - chmod [OPTION]... MODE[,MODE]... FILE...
  - chmod [OPTION]... OCTAL-MODE FILE...
  - chmod [OPTION]... --reference=RFILE FILE...
options:
  -c, --changes: like verbose but report only when a change is made
  -f, --silent, --quiet: suppress most error messages
  -v, --verbose: output a diagnostic for every file processed
  --no-preserve-root: do not treat '/' specially (the default)
  --preserve-root: fail to operate recursively on '/'
  --reference=RFILE: use RFILE's mode instead of MODE values
  -R, --recursive: change files and directories recursively
  --help: display this help and exit
  --version: output version information and exit