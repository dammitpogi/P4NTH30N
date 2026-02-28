description:
  Displays a list of currently running processes on the local computer or on a remote computer.
synopses:
  - tasklist [/s <computer> [/u [<domain>\]<username> [/p <password>]]] [{/m <module> | /svc | /v}] [/fo {table | list | csv}] [/nh] [/fi <filter> [/fi <filter> [ ... ]]]
options:
  /s <computer>: Specifies the name or IP address of a remote computer. The default is the local computer.
  /u [<domain>\]<username>: Runs the command with the account permissions of the user who is specified by <username> or by <domain>\<username>.
  /p <password>: Specifies the password of the user account that is specified in the /u parameter.
  /m <module>: Lists all tasks with DLL modules loaded that match the given pattern name. If the module name is not specified, this option displays all modules loaded by each task.
  /svc: Lists all the service information for each process without truncation. Valid when the /fo parameter is set to table.
  /v: Displays verbose task information in the output.
  /fo format:
    description: Specifies the format to use for the output.
    values:
      - table
      - list
      - csv
  /nh: Suppresses column headers in the output. Valid when the /fo parameter is set to table or csv.
  /fi <filter>: Specifies the types of processes to include in or exclude from the query.
  /?: Displays help at the command prompt.