description:
  change group ownership
synopses:
  - chgrp [OPTION]... GROUP FILE...
  - chgrp [OPTION]... --reference=RFILE FILE...
options:
  -c, --changes: like verbose but report only when a change is made
  -f, --silent, --quiet: suppress most error messages
  -v, --verbose: output a diagnostic for every file processed
  --dereference: affect the referent of each symbolic link (this is the default), rather than the symbolic link itself
  -h, --no-dereference: affect symbolic links instead of any referenced file (useful only on systems that can change the ownership of a symlink)
  --no-preserve-root: do not treat '/' specially (the default)
  --preserve-root: fail to operate recursively on '/'
  --reference=RFILE: use RFILE's group rather than specifying a GROUP value
  -R, --recursive: operate on files and directories recursively
  -H: with -R, if a command line argument is a symbolic link to a directory, traverse it
  -L: with -R, traverse every symbolic link to a directory encountered
  -P: with -R, do not traverse any symbolic links (default)
  --help: display this help and exit
  --version: output version information and exit