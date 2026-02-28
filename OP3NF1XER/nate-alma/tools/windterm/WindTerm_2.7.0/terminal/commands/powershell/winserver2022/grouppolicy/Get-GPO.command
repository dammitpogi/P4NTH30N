description: Gets one GPO or all the GPOs in a domain
synopses:
- Get-GPO [-Guid] <Guid> [[-Domain] <String>] [[-Server] <String>] [-All] [<CommonParameters>]
- Get-GPO [-Name] <String> [[-Domain] <String>] [[-Server] <String>] [-All] [<CommonParameters>]
- Get-GPO [[-Domain] <String>] [[-Server] <String>] [-All] [<CommonParameters>]
options:
  -All Switch: ~
  -Domain,-DomainName String: ~
  -Guid,-Id Guid:
    required: true
  -Name,-DisplayName String:
    required: true
  -Server,-DC String: ~
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
