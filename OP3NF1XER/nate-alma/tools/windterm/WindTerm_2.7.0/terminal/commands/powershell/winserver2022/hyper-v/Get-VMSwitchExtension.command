description: Gets the extensions on one or more virtual switches
synopses:
- Get-VMSwitchExtension [-VMSwitchName] <String[]> [[-Name] <String[]>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [<CommonParameters>]
- Get-VMSwitchExtension [-VMSwitch] <VMSwitch[]> [[-Name] <String[]>] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName,-PSComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Name String[]: ~
  -VMSwitch VMSwitch[]:
    required: true
  -VMSwitchName String[]:
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
