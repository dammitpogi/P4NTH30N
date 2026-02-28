description: Modifies a Windows MultiPoint Server user account
synopses:
- Set-WmsUser [-Name] <String> [-FullName <String>] [-Description <String>] [-UserType
  <UserTypePS>] [-Server <String>] [<CommonParameters>]
- Set-WmsUser [-Credential] <PSCredential> [-FullName <String>] [-Description <String>]
  [-UserType <UserTypePS>] [-Server <String>] [<CommonParameters>]
options:
  -Credential PSCredential:
    required: true
  -Description String: ~
  -FullName String: ~
  -Name String:
    required: true
  -Server,-ComputerName String: ~
  -UserType UserTypePS:
    values:
    - Administrator
    - Standard
    - DashboardUser
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
