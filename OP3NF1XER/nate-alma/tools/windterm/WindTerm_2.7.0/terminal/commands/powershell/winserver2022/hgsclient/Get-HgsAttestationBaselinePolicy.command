description: Generates an attestation baseline policy
synopses:
- Get-HgsAttestationBaselinePolicy -Path <String> [-Force] [-SkipValidation] [<CommonParameters>]
- Get-HgsAttestationBaselinePolicy [-Console] [-SkipValidation] [<CommonParameters>]
options:
  -Console Switch:
    required: true
  -Force Switch: ~
  -Path,-FilePath String:
    required: true
  -SkipValidation Switch: ~
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
