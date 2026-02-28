description: Imports certificates and private keys from a Personal Information Exchange
  (PFX) file to the destination store
synopses:
- Import-PfxCertificate [-Exportable] [-Password <SecureString>] [[-CertStoreLocation]
  <String>] [-FilePath] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertStoreLocation String: ~
  -Confirm,-cf Switch: ~
  -Exportable Switch: ~
  -FilePath,-FullName String:
    required: true
  -Password SecureString: ~
  -WhatIf,-wi Switch: ~
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
