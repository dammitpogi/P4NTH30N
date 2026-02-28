description: Modifies the configuration of the specified DirectAccess client user
  experience
synopses:
- Set-DAClientExperienceConfiguration [-PolicyStore <String>] [-GPOSession <String>]
  [[-CorporateResources] <String[]>] [[-IPsecTunnelEndpoints] <String[]>] [[-PreferLocalNamesAllowed]
  <Boolean>] [[-UserInterface] <Boolean>] [[-SupportEmail] <String>] [[-FriendlyName]
  <String>] [[-ManualEntryPointSelectionAllowed] <Boolean>] [[-GslbFqdn] <String>]
  [[-ForceTunneling] <ForceTunneling>] [[-CustomCommands] <String[]>] [[-PassiveMode]
  <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DAClientExperienceConfiguration -InputObject <CimInstance[]> [[-CorporateResources]
  <String[]>] [[-IPsecTunnelEndpoints] <String[]>] [[-PreferLocalNamesAllowed] <Boolean>]
  [[-UserInterface] <Boolean>] [[-SupportEmail] <String>] [[-FriendlyName] <String>]
  [[-ManualEntryPointSelectionAllowed] <Boolean>] [[-GslbFqdn] <String>] [[-ForceTunneling]
  <ForceTunneling>] [[-CustomCommands] <String[]>] [[-PassiveMode] <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CorporateResources String[]: ~
  -CustomCommands String[]: ~
  -ForceTunneling ForceTunneling:
    values:
    - Default
    - Enabled
    - Disabled
  -FriendlyName String: ~
  -GPOSession String: ~
  -GslbFqdn String: ~
  -IPsecTunnelEndpoints String[]: ~
  -InputObject CimInstance[]:
    required: true
  -ManualEntryPointSelectionAllowed Boolean: ~
  -PassThru Switch: ~
  -PassiveMode Boolean: ~
  -PolicyStore String: ~
  -PreferLocalNamesAllowed Boolean: ~
  -SupportEmail String: ~
  -ThrottleLimit Int32: ~
  -UserInterface Boolean: ~
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
