description:
  report a snapshot of the current processes.
synopses:
  - ps [options]
options:
  -A, -e: Select all processes.
  -a: Select all processes except both session leaders and processes not associated with a terminal.
  -d: Select all processes except session leaders.
  -N, --deselect: Select all processes except those that fulfill the specified conditions (negates the selection).
  -C cmdlist: Select by command name.
  -G, --Group grplist: Select by real group ID (RGID) or name.
  -g, --group grplist: Select by session OR by effective group name.
  -p, --pid pidlist: Select by PID.
  --ppid pidlist: Select by parent process ID.
  -q, --quick-pid pidlist: Select by PID (quick mode).
  -s, --sid sesslist: Select by session ID.
  -t, --tty ttylist: Select by tty.
  -U, --User userlist: Select by real user ID (RUID) or name.
  -u, --user userlist: Select by effective user ID (EUID) or name.
  -c: Show different scheduler information for the -l option.
  --context: Display security context format (for SELinux).
  -f: Do full-format listing.
  -F: Extra full format.
  -o, --format format: user-defined format.
  -j: Jobs format.
  -l: Long format.
  -M: Add a column of security data.  Identical to Z (for SELinux).
  -O format: Like -o, but preloaded with some default columns.
  -y: Do not show flags; show rss in place of addr. This option can only be used with -l.
  --cols, --columns, --width number: Set screen width.
  --cumulative: Include some dead child process data (as a sum with the parent).
  --forest: ASCII art process tree.
  -H: Show process hierarchy (forest).
  --headers: Repeat header lines, one per page of output.
  --lines, --rows number: Set screen height.
  --no-headers: Print no header line at all.
  --sort spec: Specify sorting order.
  -w: Wide output. Use this option twice for unlimited width.
  -L: Show threads, possibly with LWP and NLWP columns.
  -m: Show threads after processes.
  -T: Show threads, possibly with SPID column.
  --help section:
    description: Print a help message.
    values:
      - simple
      - list
      - output
      - threads
      - misc
      - all
  --info: Print debugging info.
  -V: Print the procps-ng version.
  --version: Print the procps-ng version.