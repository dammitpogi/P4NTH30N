description: Gets the value for one or more properties of a specified item
synopses:
- Get-ItemPropertyValue [[-Path] <String[]>] [-Name] <String[]> [-Filter <String>]
  [-Include <String[]>] [-Exclude <String[]>] [-Credential <PSCredential>] [<CommonParameters>]
- Get-ItemPropertyValue -LiteralPath <String[]> [-Name] <String[]> [-Filter <String>]
  [-Include <String[]>] [-Exclude <String[]>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Name,-PSProperty System.String[]:
    required: true
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
