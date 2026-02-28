description: Gets the hotfixes that are installed on local or remote computers
synopses:
- Get-HotFix [[-Id] <String[]>] [-ComputerName <String[]>] [-Credential <PSCredential>]
  [<CommonParameters>]
- Get-HotFix [-Description <String[]>] [-ComputerName <String[]>] [-Credential <PSCredential>]
  [<CommonParameters>]
options:
  -ComputerName,-CN,-__Server,-IPAddress System.String[]: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Description System.String[]: ~
  -Id,-HFID System.String[]: ~
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
