description: Imports an exported Host Guardian Service state into a Host Guardian
  Service instance
synopses:
- Import-HgsServerState [[-XML] <XmlDocument>] -Password <SecureString> [-ImportTpmModeState]
  [-ImportActiveDirectoryModeState] [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-HgsServerState [[-Path] <String>] -Password <SecureString> [-ImportTpmModeState]
  [-ImportActiveDirectoryModeState] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ImportActiveDirectoryModeState Switch: ~
  -ImportTpmModeState Switch: ~
  -Password SecureString:
    required: true
  -Path,-FilePath String: ~
  -XML,-InputObject XmlDocument: ~
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
