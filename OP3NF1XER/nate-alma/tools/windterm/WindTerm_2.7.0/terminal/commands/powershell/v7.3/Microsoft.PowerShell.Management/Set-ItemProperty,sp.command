description: Creates or changes the value of a property of an item
synopses:
- Set-ItemProperty [-Path] <String[]> [-Name] <String> [-Value] <Object> [-PassThru]
  [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [-Type <RegistryValueKind>] [<CommonParameters>]
- Set-ItemProperty [-Path] <String[]> -InputObject <PSObject> [-PassThru] [-Force]
  [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Credential <PSCredential>]
  [-WhatIf] [-Confirm] [-Type <RegistryValueKind>] [<CommonParameters>]
- Set-ItemProperty -LiteralPath <String[]> [-Name] <String> [-Value] <Object> [-PassThru]
  [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [-Type <RegistryValueKind>] [<CommonParameters>]
- Set-ItemProperty -LiteralPath <String[]> -InputObject <PSObject> [-PassThru] [-Force]
  [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Credential <PSCredential>]
  [-WhatIf] [-Confirm] [-Type <RegistryValueKind>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Name,-PSProperty System.String:
    required: true
  -PassThru Switch: ~
  -Path System.String[]:
    required: true
  -Type Microsoft.Win32.RegistryValueKind: ~
  -Value System.Object:
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
