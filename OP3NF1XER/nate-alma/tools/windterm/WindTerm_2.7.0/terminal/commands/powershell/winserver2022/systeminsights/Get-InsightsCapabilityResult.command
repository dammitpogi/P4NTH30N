description: Gets the most recent prediction or the last 30 predictions from the specified
  capabilities
synopses:
- Get-InsightsCapabilityResult [-Name] <String> [-History] [[-ComputerName] <String>]
  [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName,-CN String: ~
  -Credential PSCredential: ~
  -History,-H Switch: ~
  -Name,-N String:
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
