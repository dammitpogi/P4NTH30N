description: '`Test-FileCatalog` validates whether the hashes contained in a catalog
  file (.cat) matches the hashes of the actual files in order to validate their authenticity.  This
  cmdlet is only supported on Windows'
synopses:
- Test-FileCatalog [-Detailed] [-FilesToSkip <String[]>] [-CatalogFilePath] <String>
  [[-Path] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CatalogFilePath System.String:
    required: true
  -Detailed Switch: ~
  -FilesToSkip System.String[]: ~
  -Path System.String[]: ~
  -Confirm,-cf Switch: ~
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
