description: Sets a new VLAN id on a team interface, or restores the interface to
  Default mode
synopses:
- Set-NetLbfoTeamNic [[-Name] <String[]>] [[-Team] <String[]>] [-VlanID <UInt32>]
  [-Default] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetLbfoTeamNic [-TeamOfTheTeamNic <CimInstance>] [-VlanID <UInt32>] [-Default]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetLbfoTeamNic -InputObject <CimInstance[]> [-VlanID <UInt32>] [-Default] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Default Switch: ~
  -InputObject CimInstance[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]: ~
  -PassThru Switch: ~
  -Team String[]: ~
  -TeamOfTheTeamNic CimInstance: ~
  -ThrottleLimit Int32: ~
  -VlanID UInt32: ~
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
