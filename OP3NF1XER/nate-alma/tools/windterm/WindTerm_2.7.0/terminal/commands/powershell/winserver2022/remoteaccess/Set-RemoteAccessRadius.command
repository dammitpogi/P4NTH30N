description: Edits the properties associated with an external RADIUS server being
  used for VPN authentication, accounting for DirectAccess (DA) and VPN, and one-time
  password (OTP) authentication for DA
synopses:
- Set-RemoteAccessRadius [-ComputerName <String>] [-Purpose] <String> [-Port <UInt16>]
  [-Score <Byte>] [-ServerName] <String> [-Timeout <UInt32>] [-SharedSecret <String>]
  [-AccountingOnOffMsg <String>] [-MsgAuthenticator <String>] [-EntrypointName <String>]
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AccountingOnOffMsg String:
    values:
    - Enabled
    - Disabled
    - ''
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -EntrypointName String: ~
  -MsgAuthenticator String:
    values:
    - Enabled
    - Disabled
    - ''
  -PassThru Switch: ~
  -Port UInt16: ~
  -Purpose String:
    required: true
    values:
    - Authentication
    - Accounting
    - Otp
  -Score Byte: ~
  -ServerName String:
    required: true
  -SharedSecret String: ~
  -ThrottleLimit Int32: ~
  -Timeout UInt32: ~
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
