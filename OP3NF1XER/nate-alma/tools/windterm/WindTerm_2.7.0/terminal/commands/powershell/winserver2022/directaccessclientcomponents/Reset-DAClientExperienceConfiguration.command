description: Restores the specified DirectAccess client configuration to the defaults
synopses:
- Reset-DAClientExperienceConfiguration [-PolicyStore <String>] [-GPOSession <String>]
  [-CorporateResources] [-IPsecTunnelEndpoints] [-PreferLocalNamesAllowed] [-UserInterface]
  [-SupportEmail] [-FriendlyName] [-ManualEntryPointSelectionAllowed] [-GslbFqdn]
  [-ForceTunneling] [-CustomCommands] [-PassiveMode] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Reset-DAClientExperienceConfiguration -InputObject <CimInstance[]> [-CorporateResources]
  [-IPsecTunnelEndpoints] [-PreferLocalNamesAllowed] [-UserInterface] [-SupportEmail]
  [-FriendlyName] [-ManualEntryPointSelectionAllowed] [-GslbFqdn] [-ForceTunneling]
  [-CustomCommands] [-PassiveMode] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CorporateResources Switch: ~
  -CustomCommands Switch: ~
  -ForceTunneling Switch: ~
  -FriendlyName Switch: ~
  -GPOSession String: ~
  -GslbFqdn Switch: ~
  -IPsecTunnelEndpoints Switch: ~
  -InputObject CimInstance[]:
    required: true
  -ManualEntryPointSelectionAllowed Switch: ~
  -PassThru Switch: ~
  -PassiveMode Switch: ~
  -PolicyStore String: ~
  -PreferLocalNamesAllowed Switch: ~
  -SupportEmail Switch: ~
  -ThrottleLimit Int32: ~
  -UserInterface Switch: ~
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
