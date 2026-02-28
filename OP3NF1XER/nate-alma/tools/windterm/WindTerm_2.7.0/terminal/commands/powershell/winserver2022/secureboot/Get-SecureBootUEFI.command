description: Gets the UEFI variable values related to Secure Boot
synopses:
- Get-SecureBootUEFI [-Name] <String> [-OutputFilePath <String>] [<CommonParameters>]
options:
  -Name,-n String:
    required: true
    values:
    - PK
    - KEK
    - db
    - dbx
    - SetupMode
    - SecureBoot
    - PKDefault
    - KEKDefault
    - dbDefault
    - dbxDefault
    - dbt
    - dbtDefault
  -OutputFilePath,-f String: ~
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
