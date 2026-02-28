description: Gets entries showing users and the virtual machines to which they can
  connect on one or more Hyper-V hosts
synopses:
- Get-VMConnectAccess [[-VMName] <String[]>] [-UserName <String[]>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [<CommonParameters>]
- Get-VMConnectAccess [-VMId] <Guid[]> [-UserName <String[]>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -UserName,-UserId,-Sid String[]: ~
  -VMId Guid[]:
    required: true
  -VMName String[]: ~
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
