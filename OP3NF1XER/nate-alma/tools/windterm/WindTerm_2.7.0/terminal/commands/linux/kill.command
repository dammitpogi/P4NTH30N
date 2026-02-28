description:
  send a signal to a process
synopses:
  - kill [options] <pid> [...]  
options:
  -l, --list number: List signal names.
  -L, --table: List signal names in a nice table.
  -s, --signal singal:
    description: Specify the signal to be sent.  The signal can be specified by using name or number.
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
PARAMETERS:
  <pid>:
    values:
      -1, -HUP, -SIGHUP: Send the signal SIGHUP
      -2, -INT, -SIGINT: Send the signal SIGINT
      -3, -QUIT, -SIGQUIT: Send the signal SIGQUIT
      -4, -ILL, -SIGILL: Send the signal SIGILL
      -5, -TRAP, -SIGTRAP: Send the signal SIGTRAP
      -6, -ABRT, -SIGABRT: Send the signal SIGABRT
      -7, -BUS, -SIGBUS: Send the signal SIGBUS
      -8, -FPE, -SIGFPE: Send the signal SIGFPE
      -9, -KILL, -SIGKILL: Send the signal SIGKILL
      -10, -USR1, -SIGUSR1: Send the signal SIGUSR1
      -11, -SEGV, -SIGSEGV: Send the signal SIGSEGV
      -12, -USR2, -SIGUSR2: Send the signal SIGUSR2
      -13, -PIPE, -SIGPIPE: Send the signal SIGPIPE
      -14, -ALRM, -SIGALRM: Send the signal SIGALRM
      -15, -TERM, -SIGTERM: Send the signal SIGTERM
      -16, -STKFLT, -SIGSTKFLT: Send the signal SIGSTKFLT
      -17, -CHLD, -SIGCHLD: Send the signal SIGCHLD
      -18, -CONT, -SIGCONT: Send the signal SIGCONT
      -19, -STOP, -SIGSTOP: Send the signal SIGSTOP
      -20, -TSTP, -SIGTSTP: Send the signal SIGTSTP
      -21, -TTIN, -SIGTTIN: Send the signal SIGTTIN
      -22, -TTOU, -SIGTTOU: Send the signal SIGTTOU
      -23, -URG, -SIGURG: Send the signal SIGURG
      -24, -XCPU, -SIGXCPU: Send the signal SIGXCPU
      -25, -XFSZ, -SIGXFSZ: Send the signal SIGXFSZ
      -26, -VTALRM, -SIGVTALRM: Send the signal SIGVTALRM
      -27, -PROF, -SIGPROF: Send the signal SIGPROF
      -28, -WINCH, -SIGWINCH: Send the signal SIGWINCH
      -29, -IO, -SIGIO: Send the signal SIGIO
      -30, -PWR, -SIGPWR: Send the signal SIGPWR
      -31, -SYS, -SIGSYS: Send the signal SIGSYS
