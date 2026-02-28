description:
  output the first part of files
synopses:
  - head [OPTION]... [FILE]...
options:
  -c, --bytes=[-]NUM: "print the first NUM bytes of each file; with the leading '-', print all but the last NUM bytes of each file; NUM may have a multiplier suffix: b 512, kB 1000, K 1024,	MB 1000*1000,	M 1024*1024, GB 1000*1000*1000, G 1024*1024*1024, and so on for T, P, E, Z, Y"
  -n, --lines=[-]NUM: "print the first NUM lines instead of the first 10; with the leading '-', print all but the last NUM lines of each file; NUM may have a multiplier suffix: b 512, kB 1000, K 1024,	MB 1000*1000,	M 1024*1024, GB 1000*1000*1000, G 1024*1024*1024, and so on for T, P, E, Z, Y"
  -q, --quiet, --silent: never print headers giving file names
  -v, --verbose: always print headers giving file names
  -z, --zero-terminated: line delimiter is NUL, not newline
  --help: display this help and exit
  --version: output version information and exit