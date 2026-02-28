description: Removes a member from a virtual machine switch team
synopses:
- Remove-VMSwitchTeamMember [-ComputerName <String[]>] [-VMSwitchName] <String[]>
  [-NetAdapterName <String[]>] [-Passthru] [-CimSession <CimSession[]>] [-Credential
  <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMSwitchTeamMember [-ComputerName <String[]>] [-VMSwitchName] <String[]>
  [-NetAdapterInterfaceDescription <String[]>] [-Passthru] [-CimSession <CimSession[]>]
  [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMSwitchTeamMember [-ComputerName <String[]>] [-VMSwitch] <VMSwitch[]> [-NetAdapterInterfaceDescription
  <String[]>] [-Passthru] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMSwitchTeamMember [-ComputerName <String[]>] [-VMSwitch] <VMSwitch[]> [-NetAdapterName
  <String[]>] [-Passthru] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName,-PSComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -NetAdapterInterfaceDescription String[]: ~
  -NetAdapterName,-InterfaceAlias String[]: ~
  -Passthru Switch: ~
  -VMSwitch VMSwitch[]:
    required: true
  -VMSwitchName,-SwitchName String[]:
    required: true
  -WhatIf,-wi Switch: ~
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
