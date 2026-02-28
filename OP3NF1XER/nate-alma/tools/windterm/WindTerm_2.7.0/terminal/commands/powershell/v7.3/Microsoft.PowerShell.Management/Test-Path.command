description: Determines whether all elements of a path exist
synopses:
- Test-Path [-Path] <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude
  <String[]>] [-PathType <TestPathType>] [-IsValid] [-Credential <PSCredential>] [-OlderThan
  <DateTime>] [-NewerThan <DateTime>] [<CommonParameters>]
- Test-Path -LiteralPath <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude
  <String[]>] [-PathType <TestPathType>] [-IsValid] [-Credential <PSCredential>] [-OlderThan
  <DateTime>] [-NewerThan <DateTime>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Include System.String[]: ~
  -IsValid Switch: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -NewerThan System.Nullable`1[System.DateTime]: ~
  -OlderThan System.Nullable`1[System.DateTime]: ~
  -Path System.String[]:
    required: true
  -PathType,-Type Microsoft.PowerShell.Commands.TestPathType:
    values:
    - Any
    - Container
    - Leaf
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
