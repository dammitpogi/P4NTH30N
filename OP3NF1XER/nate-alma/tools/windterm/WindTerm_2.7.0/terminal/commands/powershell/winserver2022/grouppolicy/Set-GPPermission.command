description: Grants a level of permissions to a security principal for one GPO or
  all the GPOs in a domain
synopses:
- Set-GPPermission -Guid <Guid> -PermissionLevel <GPPermissionType> -TargetName <String>
  -TargetType <PermissionTrusteeType> [-DomainName <String>] [-Server <String>] [-Replace]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-GPPermission [-Name] <String> -PermissionLevel <GPPermissionType> -TargetName
  <String> -TargetType <PermissionTrusteeType> [-DomainName <String>] [-Server <String>]
  [-Replace] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-GPPermission -PermissionLevel <GPPermissionType> -TargetName <String> -TargetType
  <PermissionTrusteeType> [-DomainName <String>] [-Server <String>] [-All] [-Replace]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -Confirm,-cf Switch: ~
  -DomainName,-Domain String: ~
  -Guid,-ID Guid:
    required: true
  -Name,-DisplayName String:
    required: true
  -PermissionLevel GPPermissionType:
    required: true
    values:
    - None
    - GpoApply
    - GpoRead
    - GpoEdit
    - GpoEditDeleteModifySecurity
    - GpoCustom
    - WmiFilterEdit
    - WmiFilterFullControl
    - WmiFilterCustom
    - StarterGpoRead
    - StarterGpoEdit
    - StarterGpoFullControl
    - StarterGpoCustom
    - SomCreateWmiFilter
    - SomWmiFilterFullControl
    - SomCreateGpo
    - SomCreateStarterGpo
    - SomLogging
    - SomPlanning
    - SomLink
  -Replace Switch: ~
  -Server,-DC String: ~
  -TargetName String:
    required: true
  -TargetType PermissionTrusteeType:
    required: true
    values:
    - Computer
    - User
    - Group
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
