description: Creates a HGS Diagnostics target object
synopses:
- New-HgsTraceTarget -HostName <String> [-Credential <PSCredential>] [-PSSessionConfigurationName
  <String>] [-Role <BaseHgsRoles[]>] [<CommonParameters>]
- New-HgsTraceTarget -HostName <String> [-NoAccess] -Role <BaseHgsRoles[]> [<CommonParameters>]
- New-HgsTraceTarget [-Local] [-Role <BaseHgsRoles[]>] [<CommonParameters>]
options:
  -Credential PSCredential: ~
  -HostName String:
    required: true
  -Local Switch:
    required: true
  -NoAccess Switch:
    required: true
  -PSSessionConfigurationName String: ~
  -Role BaseHgsRoles[]:
    values:
    - None
    - HostGuardianService
    - GuardedHost
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
