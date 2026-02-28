description: Gets the permission level for one or more security principals on a specified
  GPO
synopses:
- Get-GPPermission -Guid <Guid> [-TargetName <String>] [-TargetType <PermissionTrusteeType>]
  [-DomainName <String>] [-Server <String>] [-All] [<CommonParameters>]
- Get-GPPermission [-Name] <String> [-TargetName <String>] [-TargetType <PermissionTrusteeType>]
  [-DomainName <String>] [-Server <String>] [-All] [<CommonParameters>]
options:
  -All Switch: ~
  -DomainName,-Domain String: ~
  -Guid,-ID Guid:
    required: true
  -Name,-DisplayName String:
    required: true
  -Server,-DC String: ~
  -TargetName String: ~
  -TargetType PermissionTrusteeType:
    values:
    - Computer
    - User
    - Group
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
