description:
  display Linux processes
synopses:
  - top [-hv|-bcHiOSs] [-d secs] [-n max] [-u user | -U user] [-p pid] [-o fld] -w [cols]
options:
  -h:
    tip: Help
    description: Show library version and the usage prompt, then quit.
  -v:
    tip: Version
    description: Show library version and the usage prompt, then quit.
  -b:
    tip: Batch mode
    description: Starts top in Batch mode
  -c:
    tip: Command line/Program name toggle
    description: Starts top with the last remembered `c' state reversed.
  -d seconds: Specifies the delay between screen updates
  -H:
    tip: Threads mode
    description: Instructs top to display individual threads.
  -i:
    tip: Idle process toggle
    description: Starts top with the last remembered `i' state reversed.
  -n number: Specifies the maximum number of iterations, or frames, top should produce before ending.
  -o fieldname: Specifies the name of the field on which tasks will be sorted
  -O:
    tip: Output field names
    description: This option acts as a form of help for the above -o option.
  -p pid: Monitor only processes with specified process IDs.
  -s:
    tip: Secure mode
    description: Starts top with secure mode forced, even for root.
  -S:
    tip: Cumulative time toggle
    description: Starts  top with the last remembered `S' state reversed.
  -u, -U user: Display only processes with a user id or user name matching that given.
  -w [columns]: Increase or decrease the output width.