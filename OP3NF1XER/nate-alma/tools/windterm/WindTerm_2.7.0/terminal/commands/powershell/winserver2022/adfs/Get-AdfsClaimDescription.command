description: Gets claim descriptions from the Federation Service
synopses:
- Get-AdfsClaimDescription [[-Name] <String[]>] [<CommonParameters>]
- Get-AdfsClaimDescription -ClaimType <String[]> [<CommonParameters>]
- Get-AdfsClaimDescription -ShortName <String[]> [<CommonParameters>]
options:
  -ClaimType String[]:
    required: true
  -Name String[]: ~
  -ShortName String[]:
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
