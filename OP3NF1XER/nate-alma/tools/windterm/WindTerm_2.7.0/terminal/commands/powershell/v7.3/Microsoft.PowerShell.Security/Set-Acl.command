description: Changes the security descriptor of a specified item, such as a file or
  a registry key
synopses:
- Set-Acl [-Path] <String[]> [-AclObject] <Object> [-ClearCentralAccessPolicy] [-Passthru]
  [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-Acl [-InputObject] <PSObject> [-AclObject] <Object> [-Passthru] [-Filter <String>]
  [-Include <String[]>] [-Exclude <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Acl -LiteralPath <String[]> [-AclObject] <Object> [-ClearCentralAccessPolicy]
  [-Passthru] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AclObject System.Object:
    required: true
  -ClearCentralAccessPolicy Switch: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Include System.String[]: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -LiteralPath,-PSPath System.String[]:
    required: true
  -Passthru Switch: ~
  -Path System.String[]:
    required: true
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
