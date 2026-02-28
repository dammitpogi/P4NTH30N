description: Gets the security descriptor for a resource, such as a file or registry
  key
synopses:
- Get-Acl [[-Path] <String[]>] [-Audit] [-Filter <String>] [-Include <String[]>] [-Exclude
  <String[]>] [<CommonParameters>]
- Get-Acl -InputObject <PSObject> [-Audit] [-Filter <String>] [-Include <String[]>]
  [-Exclude <String[]>] [<CommonParameters>]
- Get-Acl [-LiteralPath <String[]>] [-Audit] [-Filter <String>] [-Include <String[]>]
  [-Exclude <String[]>] [<CommonParameters>]
options:
  -Audit Switch: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Include System.String[]: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -LiteralPath,-PSPath System.String[]: ~
  -Path System.String[]: ~
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
