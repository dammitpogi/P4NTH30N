description: Gets one or more Registry preference items under either Computer Configuration
  or User Configuration in a GPO
synopses:
- Get-GPPrefRegistryValue -Guid <Guid> -Context <GpoConfiguration> -Key <String> [-ValueName
  <String>] [-Order <Int32>] [-Domain <String>] [-Server <String>] [<CommonParameters>]
- Get-GPPrefRegistryValue [-Name] <String> -Context <GpoConfiguration> -Key <String>
  [-ValueName <String>] [-Order <Int32>] [-Domain <String>] [-Server <String>] [<CommonParameters>]
options:
  -Context GpoConfiguration:
    required: true
    values:
    - User
    - Computer
  -Domain,-DomainName String: ~
  -Guid,-Id Guid:
    required: true
  -Key,-FullKeyPath String:
    required: true
  -Name,-DisplayName String:
    required: true
  -Order Int32: ~
  -Server,-DC String: ~
  -ValueName String: ~
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
