description: Gets the replication and authentication settings of a Replica server
synopses:
- Get-VMReplicationServer [[-ComputerName] <String[]>] [[-Credential] <PSCredential[]>]
  [<CommonParameters>]
- Get-VMReplicationServer [-CimSession] <CimSession[]> [<CommonParameters>]
options:
  -CimSession CimSession[]:
    required: true
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
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
