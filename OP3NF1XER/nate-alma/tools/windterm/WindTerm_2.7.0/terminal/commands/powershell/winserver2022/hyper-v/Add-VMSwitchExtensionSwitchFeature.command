description: Adds a feature to a virtual switch
synopses:
- Add-VMSwitchExtensionSwitchFeature [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] -VMSwitchExtensionFeature <VMSwitchExtensionSwitchFeature[]>
  [-SwitchName] <String[]> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMSwitchExtensionSwitchFeature -VMSwitchExtensionFeature <VMSwitchExtensionSwitchFeature[]>
  [-VMSwitch] <VMSwitch[]> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -SwitchName String[]:
    required: true
  -VMSwitch VMSwitch[]:
    required: true
  -VMSwitchExtensionFeature VMSwitchExtensionSwitchFeature[]:
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
