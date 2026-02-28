description: Retrieves registration information for an OAuth 2.0 client
synopses:
- Get-AdfsClient [[-Name] <String[]>] [<CommonParameters>]
- Get-AdfsClient [-ClientId] <String[]> [<CommonParameters>]
- Get-AdfsClient [-InputObject] <AdfsClient> [<CommonParameters>]
options:
  -ClientId String[]:
    required: true
  -InputObject AdfsClient:
    required: true
  -Name String[]: ~
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
