description:
  make links between files
synopses:
  - ln [OPTION]... [-T] TARGET LINK_NAME
  - ln [OPTION]... TARGET
  - ln [OPTION]... TARGET... DIRECTORY
  - ln [OPTION]... -t DIRECTORY TARGET...
options:
  --backup[=CONTROL]:
    description: make a backup of each existing destination file
    values:
      - none
      - numbered
      - existing
      - simple
  -b: like --backup but does not accept an argument
  -d, -F, --directory: allow the superuser to attempt to hard link directories
  -f, --force: remove existing destination files
  -i, --interactive: prompt whether to remove destinations
  -L, --logical: dereference TARGETs that are symbolic links
  -n, --no-dereference: treat LINK_NAME as a normal file if it is a symbolic link to a directory
  -P, --physical: make hard links directly to symbolic links
  -r, --relative: create symbolic links relative to link location
  -s, --symbolic: make symbolic links instead of hard links
  -S, --suffix=SUFFIX: override the usual backup suffix
  -t, --target-directory=DIRECTORY: specify the DIRECTORY in which to create the links
  -T, --no-target-directory: treat LINK_NAME as a normal file always
  -v, --verbose: print name of each linked file
  --help: display this help and exit
  --version: output version information and exit