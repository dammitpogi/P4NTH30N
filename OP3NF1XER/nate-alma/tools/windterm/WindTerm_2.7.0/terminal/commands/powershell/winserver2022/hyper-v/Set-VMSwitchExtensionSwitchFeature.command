description: Configures a feature on a virtual switch
synopses:
- Set-VMSwitchExtensionSwitchFeature -VMSwitchExtensionFeature <VMSwitchExtensionSwitchFeature[]>
  [-Passthru] [-ComputerName <String[]>] [-SwitchName <String[]>] [-VMSwitch <VMSwitch[]>]
  [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -SwitchName String[]: ~
  -VMSwitch VMSwitch[]: ~
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
