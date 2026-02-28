description: Configures a Registry preference item under either Computer Configuration
  or User Configuration in a GPO
synopses:
- Set-GPPrefRegistryValue -Guid <Guid> -Context <GpoConfiguration> -Key <String> [-ValueName
  <String>] [-Value <PSObject>] [-Type <RegistryValueKind>] -Action <PreferenceAction>
  [-Order <Int32>] [-Domain <String>] [-Server <String>] [-Disable] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-GPPrefRegistryValue [-Name] <String> -Context <GpoConfiguration> -Key <String>
  [-ValueName <String>] [-Value <PSObject>] [-Type <RegistryValueKind>] -Action <PreferenceAction>
  [-Order <Int32>] [-Domain <String>] [-Server <String>] [-Disable] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Action PreferenceAction:
    required: true
    values:
    - Create
    - Replace
    - Update
    - Delete
  -Confirm,-cf Switch: ~
  -Context GpoConfiguration:
    required: true
    values:
    - User
    - Computer
  -Disable Switch: ~
  -Domain,-DomainName String: ~
  -Guid,-Id Guid:
    required: true
  -Key,-FullKeyPath String:
    required: true
  -Name,-DisplayName String:
    required: true
  -Order Int32: ~
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
  -ValueName String: ~
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
