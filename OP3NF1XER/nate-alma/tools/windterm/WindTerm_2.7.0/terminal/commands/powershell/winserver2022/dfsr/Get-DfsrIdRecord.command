description: Gets ID records for replicated files or folders from the DFS Replication
  database
synopses:
- Get-DfsrIdRecord [-Path] <String[]> [[-ComputerName] <String>] [<CommonParameters>]
- Get-DfsrIdRecord [-Uid] <String[]> [[-ComputerName] <String>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Path,-FullName String[]:
    required: true
  -Uid String[]:
    required: true
  -Debug,-db Switch: ~
  -ErrorAction,-ea ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -ErrorVariable,-ev String: ~
  -InformationAction,-ia ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -InformationVariable,-iv String: ~
  -OutVariable,-ov String: ~
  -OutBuffer,-ob Int32: ~
  -PipelineVariable,-pv String: ~
  -Verbose,-vb Switch: ~
  -WarningAction,-wa ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -WarningVariable,-wv String: ~
