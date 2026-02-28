description: Uninstalls a module
synopses:
- Uninstall-Module [-Name] <String[]> [-MinimumVersion <String>] [-RequiredVersion
  <String>] [-MaximumVersion <String>] [-AllVersions] [-Force] [-AllowPrerelease]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Uninstall-Module [-InputObject] <PSObject[]> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowPrerelease Switch: ~
  -AllVersions Switch: ~
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject[]:
    required: true
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]:
    required: true
  -RequiredVersion System.String: ~
  -Confirm,-cf Switch: ~
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
