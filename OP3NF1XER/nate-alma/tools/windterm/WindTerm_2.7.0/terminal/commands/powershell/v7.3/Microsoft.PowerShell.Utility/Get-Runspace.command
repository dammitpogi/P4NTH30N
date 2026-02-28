description: Gets active runspaces within a PowerShell host process
synopses:
- Get-Runspace [[-Name] <String[]>] [<CommonParameters>]
- Get-Runspace [-Id] <Int32[]> [<CommonParameters>]
- Get-Runspace [-InstanceId] <Guid[]> [<CommonParameters>]
options:
  -Id System.Int32[]:
    required: true
  -InstanceId System.Guid[]:
    required: true
  -Name System.String[]: ~
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
