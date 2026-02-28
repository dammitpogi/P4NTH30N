description: Gets the virtual machines from one or more Hyper-V hosts
synopses:
- Get-VM [[-Name] <String[]>] [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [<CommonParameters>]
- Get-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [[-Id] <Guid>] [<CommonParameters>]
- Get-VM [-ClusterObject] <PSObject> [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ClusterObject PSObject:
    required: true
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Id Guid: ~
  -Name,-VMName String[]: ~
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
