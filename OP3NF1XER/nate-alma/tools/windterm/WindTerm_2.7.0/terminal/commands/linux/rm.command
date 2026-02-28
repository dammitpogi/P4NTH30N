description:
  remove files or directories
synopses:
  - rm [OPTION]... [FILE]...
options:
  -f, --force: ignore nonexistent files and arguments, never prompt
  -i: prompt before every removal
  -I: prompt once before removing more than three files, or when removing recursively
  --interactive[=WHEN]: 'prompt according to WHEN: never, once (-I), or always (-i); without WHEN, prompt always'
  --one-file-system: when removing a hierarchy recursively, skip any directory that is on a file system different from that of the corresponding command line argument
  --no-preserve-root: do not treat '/' specially
  --preserve-root: do not remove '/' (default)
  -r, -R, --recursive: remove directories and their contents recursively
  -d, --dir: remove empty directories
  -v, --verbose: explain what is being done
  --help: display this help and exit
  --version: output version information and exit