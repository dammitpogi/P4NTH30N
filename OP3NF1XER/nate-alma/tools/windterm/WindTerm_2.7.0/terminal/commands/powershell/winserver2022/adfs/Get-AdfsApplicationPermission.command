description: Gets permission for an application
synopses:
- Get-AdfsApplicationPermission [[-Identifiers] <String[]>] [<CommonParameters>]
- Get-AdfsApplicationPermission [[-ClientRoleIdentifiers] <String[]>] [<CommonParameters>]
- Get-AdfsApplicationPermission [[-ServerRoleIdentifiers] <String[]>] [<CommonParameters>]
options:
  -ClientRoleIdentifiers String[]: ~
  -Identifiers String[]: ~
  -ServerRoleIdentifiers String[]: ~
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
