description: Saves the events collected by the ETW session to an .etl file
synopses:
- Save-EtwTraceSession [-Name] <String> [-OutputFile <FileInfo>] [-OutputFolder <DirectoryInfo>]
  [-Stop] [-Overwrite] [-CimSession <CimSession>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession: ~
  -Confirm,-cf Switch: ~
  -Name String:
    required: true
  -OutputFile FileInfo: ~
  -OutputFolder DirectoryInfo: ~
  -Overwrite Switch: ~
  -Stop Switch: ~
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
