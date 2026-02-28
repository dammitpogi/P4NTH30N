description: Gets a credential object based on a user name and password
synopses:
- Get-Credential [[-Credential] <PSCredential>] [<CommonParameters>]
- Get-Credential [-Message <String>] [[-UserName] <String>] [-Title <String>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Message System.String: ~
  -Title System.String: ~
  -UserName System.String: ~
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
