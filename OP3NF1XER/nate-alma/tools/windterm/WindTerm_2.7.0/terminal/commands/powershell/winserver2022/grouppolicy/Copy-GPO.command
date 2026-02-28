description: Copies a GPO
synopses:
- Copy-GPO -SourceGuid <Guid> -TargetName <String> [-SourceDomain <String>] [-TargetDomain
  <String>] [-SourceDomainController <String>] [-TargetDomainController <String>]
  [-MigrationTable <String>] [-CopyAcl] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-GPO [-SourceName] <String> -TargetName <String> [-SourceDomain <String>] [-TargetDomain
  <String>] [-SourceDomainController <String>] [-TargetDomainController <String>]
  [-MigrationTable <String>] [-CopyAcl] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -CopyAcl Switch: ~
  -MigrationTable String: ~
  -SourceDomain,-DomainName String: ~
  -SourceDomainController String: ~
  -SourceGuid,-Id Guid:
    required: true
  -SourceName,-DisplayName String:
    required: true
  -TargetDomain String: ~
  -TargetDomainController String: ~
  -TargetName String:
    required: true
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
