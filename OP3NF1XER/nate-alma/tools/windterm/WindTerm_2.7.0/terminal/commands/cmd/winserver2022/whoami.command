description:
  Displays user, group and privileges information for the user who is currently logged on to the local system.
synopses:
  - whoami [/upn | /fqdn | /logonid]
  - whoami {[/user] [/groups] [/priv]} [/fo <Format>] [/nh]
  - whoami /all [/fo <Format>] [/nh]
options:
  /upn: Displays the user name in user principal name (UPN) format.
  /fqdn: Displays the user name in fully qualified domain name (FQDN) format.
  /logonid: Displays the logon ID of the current user.
  /user: Displays the current domain and user name and the security identifier (SID).
  /groups: Displays the user groups to which the current user belongs.
  /priv: Displays the security privileges of the current user.
  /fo <Format>:
    description: Specifies the output format.
    values:
      - table
      - list
      - csv
  /all: Displays all information in the current access token.
  /nh: Specifies that the column header should not be displayed in the output. This is valid only for table and CSV formats.
  /?: Displays help at the command prompt.