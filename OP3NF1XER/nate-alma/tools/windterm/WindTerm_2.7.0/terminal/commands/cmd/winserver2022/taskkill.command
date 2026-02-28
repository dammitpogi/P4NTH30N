description:
  Ends one or more tasks or processes.
synopses:
  - taskkill [/s <computer> [/u [<domain>\]<username> [/p [<password>]]]] {[/fi <filter>] [...]
    [/pid <processID> | /im <imagename>]} [/f] [/t]
options:
  /s <computer>: Specifies the name or IP address of a remote computer (do not use backslashes). The default is the local computer.
  /u [<domain>\]<username>: Runs the command with the account permissions of the user who is specified by <username> or by <domain>\<username>.
  /p <password>: Specifies the password of the user account that is specified in the /u parameter.
  /fi <filter>: Applies a filter to select a set of tasks.
  /pid <processID>: Specifies the process ID of the process to be terminated.
  /im <imagename>: Specifies the image name of the process to be terminated. Use the wildcard character (*) to specify all image names.
  /f: Specifies that processes be forcefully ended.
  /t: Ends the specified process and any child processes started by it.
  /?: Displays help at the command prompt.