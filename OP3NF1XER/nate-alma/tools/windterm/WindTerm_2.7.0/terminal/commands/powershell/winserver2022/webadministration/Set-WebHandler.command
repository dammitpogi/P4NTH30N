description: Configures an IIS request handler
synopses:
- Set-WebHandler [-Name] <String> [-Path <String>] [-Verb <String>] [-Type <String>]
  [-Modules <String>] [-ScriptProcessor <String>] [-Precondition <String>] [-ResourceType
  <String>] [-RequiredAccess <String>] [-Location <String[]>] [[-PSPath] <String[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Location String[]: ~
  -Modules String: ~
  -Name String:
    required: true
  -PSPath String[]: ~
  -Path String: ~
  -Precondition String: ~
  -RequiredAccess String:
    values:
    - None
    - Read
    - Write
    - Script
    - Execute
  -ResourceType String:
    values:
    - File
    - Directory
    - Either
    - Unspecified
  -ScriptProcessor String: ~
  -Type String: ~
  -Verb String: ~
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
