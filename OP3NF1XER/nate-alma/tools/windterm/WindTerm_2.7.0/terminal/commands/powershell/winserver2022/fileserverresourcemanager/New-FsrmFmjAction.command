description: Returns an action object for file management jobs
synopses:
- New-FsrmFmjAction [-Type] <FmjActionTypeEnum> [-ExpirationFolder <String>] [-RmsFolderOwner]
  [-RmsFullControlUser <String[]>] [-RmsReadUser <String[]>] [-RmsWriteUser <String[]>]
  [-RmsTemplate <String>] [-Command <String>] [-WorkingDirectory <String>] [-CommandParameters
  <String>] [-SecurityLevel <FmjActionSecurityLevelEnum>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Command String: ~
  -CommandParameters String: ~
  -Confirm,-cf Switch: ~
  -ExpirationFolder String: ~
  -RmsFolderOwner Switch: ~
  -RmsFullControlUser String[]: ~
  -RmsReadUser String[]: ~
  -RmsTemplate String: ~
  -RmsWriteUser String[]: ~
  -SecurityLevel FmjActionSecurityLevelEnum:
    values:
    - None
    - NetworkService
    - LocalService
    - LocalSystem
  -ThrottleLimit Int32: ~
  -Type FmjActionTypeEnum:
    required: true
    values:
    - Expiration
    - Custom
    - Rms
  -WhatIf,-wi Switch: ~
  -WorkingDirectory String: ~
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
