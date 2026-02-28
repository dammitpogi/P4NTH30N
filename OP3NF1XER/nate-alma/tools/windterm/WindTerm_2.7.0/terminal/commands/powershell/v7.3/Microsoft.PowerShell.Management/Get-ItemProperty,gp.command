description: Gets the properties of a specified item
synopses:
- Get-ItemProperty [-Path] <String[]> [[-Name] <String[]>] [-Filter <String>] [-Include
  <String[]>] [-Exclude <String[]>] [-Credential <PSCredential>] [<CommonParameters>]
- Get-ItemProperty -LiteralPath <String[]> [[-Name] <String[]>] [-Filter <String>]
  [-Include <String[]>] [-Exclude <String[]>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Name,-PSProperty System.String[]: ~
  -Path System.String[]:
    required: true
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
