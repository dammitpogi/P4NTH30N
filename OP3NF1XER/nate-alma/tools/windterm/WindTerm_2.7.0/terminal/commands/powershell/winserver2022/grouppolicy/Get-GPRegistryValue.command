description: Gets one or more registry-based policy settings under either Computer
  Configuration or User Configuration in a GPO
synopses:
- Get-GPRegistryValue -Guid <Guid> -Key <String> [-ValueName <String>] [-Domain <String>]
  [-Server <String>] [<CommonParameters>]
- Get-GPRegistryValue [-Name] <String> -Key <String> [-ValueName <String>] [-Domain
  <String>] [-Server <String>] [<CommonParameters>]
options:
  -Domain,-DomainName String: ~
  -Guid,-Id Guid:
    required: true
  -Key,-FullKeyPath String:
    required: true
  -Name,-DisplayName String:
    required: true
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
