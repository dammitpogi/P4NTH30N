description: Gets the features configured on a virtual switch
synopses:
- Get-VMSwitchExtensionSwitchFeature [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-SwitchName] <String[]> [-FeatureName <String[]>]
  [-FeatureId <Guid[]>] [-Extension <VMSwitchExtension[]>] [-ExtensionName <String[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Get-VMSwitchExtensionSwitchFeature [-VMSwitch] <VMSwitch[]> [-FeatureName <String[]>]
  [-FeatureId <Guid[]>] [-Extension <VMSwitchExtension[]>] [-ExtensionName <String[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Extension VMSwitchExtension[]: ~
  -ExtensionName String[]: ~
  -FeatureId Guid[]: ~
  -FeatureName String[]: ~
  -SwitchName String[]:
    required: true
  -VMSwitch VMSwitch[]:
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
