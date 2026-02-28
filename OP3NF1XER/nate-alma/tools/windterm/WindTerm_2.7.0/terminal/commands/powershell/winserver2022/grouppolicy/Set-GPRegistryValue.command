description: Configures one or more registry-based policy settings under either Computer
  Configuration or User Configuration in a GPO
synopses:
- Set-GPRegistryValue -Guid <Guid> -Key <String> [-ValueName <String[]>] [-Value <PSObject>]
  [-Type <RegistryValueKind>] [-Domain <String>] [-Server <String>] [-Additive] [-Disable]
  [-ValuePrefix <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-GPRegistryValue [-Name] <String> -Key <String> [-ValueName <String[]>] [-Value
  <PSObject>] [-Type <RegistryValueKind>] [-Domain <String>] [-Server <String>] [-Additive]
  [-Disable] [-ValuePrefix <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Additive Switch: ~
  -Confirm,-cf Switch: ~
  -Disable Switch: ~
  -Domain,-DomainName String: ~
  -Guid,-Id Guid:
    required: true
  -Key,-FullKeyPath String:
    required: true
  -Name,-DisplayName String:
    required: true
  -Server,-DC String: ~
  -Type RegistryValueKind:
    values:
    - Unknown
    - String
    - ExpandString
    - Binary
    - DWord
    - MultiString
    - QWord
    - None
  -Value PSObject: ~
  -ValueName String[]: ~
  -ValuePrefix String: ~
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
