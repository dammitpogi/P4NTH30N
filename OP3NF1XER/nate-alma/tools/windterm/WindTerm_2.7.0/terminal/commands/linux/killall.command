description:
  kill processes by name
synopses:
  - killall [-Z, --context pattern] [-e, --exact] [-g, --process-group] [-i, --interactive] [-n, --ns PID] [-o, --older-than TIME] [-q, --quiet] [-r, --regexp] [-s, --signal SIGNAL] [-u, --user user] [-v, --verbose] [-w, --wait] [-y, --younger-than TIME] [-I, --ignore-case] [-V, --version] [--] name ...
  - killall -l
  - killall -V, --version
options:
  -e, --exact: Require an exact match for very long names.
  -I, --ignore-case: Do case insensitive process name match.
  -g, --process-group: Kill the process group to which the process belongs.
  -i, --interactive: Interactively ask for confirmation before killing.
  -l, --list: List all known signal names.
  -n, --ns pid: Match against the PID namespace of the given PID. Use 0 to match against all namespaces. The default is to match against the current PID namespace.
  -o, --older-than time: Match only processes that are older (started before) the time specified.
  -q, --quiet: Do not complain if no processes were killed.
  -r, --regexp: Interpret process name pattern as a POSIX extended regular expression.
  -s, --signal signal:
    description: Send this signal instead of SIGTERM.
    values:
      - SIGHUP
      - SIGINT
      - SIGQUIT
      - SIGILL
      - SIGTRAP
      - SIGABRT
      - SIGBUS
      - SIGFPE
      - SIGKILL
      - SIGUSR1
      - SIGSEGV
      - SIGUSR2
      - SIGPIPE
      - SIGALRM
      - SIGTERM
      - SIGSTKFLT
      - SIGCHLD
      - SIGCONT
      - SIGSTOP
      - SIGTSTP
      - SIGTTIN
      - SIGTTOU
      - SIGURG
      - SIGXCPU
      - SIGXFSZ
      - SIGVTALRM
      - SIGPROF
      - SIGWINCH
      - SIGIO
      - SIGPWR
      - SIGSYS
  -u, --user user: Kill only processes the specified user owns.
  -v, --verbose: Report if the signal was successfully sent.
  -V, --version: Display version information.
  -w, --wait: Wait for all killed processes to die.
  -y, --younger-than time: Match only processes that are younger (started after) the time specified.
  -Z, --context pattern: (SELinux	Only) Specify security context.