description: Sets the authentication type to be used for connecting to a VPN
synopses:
- Set-VpnAuthType [-Type] <String> [[-RadiusServer] <String>] [[-SharedSecret] <String>]
  [-RadiusTimeout <UInt32>] [-RadiusScore <Byte>] [-RadiusPort <UInt16>] [-ComputerName
  <String>] [-MsgAuthenticator <String>] [-EntrypointName <String>] [-PassThru] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -EntrypointName String: ~
  -MsgAuthenticator String:
    values:
    - Enabled
    - Disabled
  -PassThru Switch: ~
  -RadiusPort,-Port UInt16: ~
  -RadiusScore,-Score Byte: ~
  -RadiusServer,-ServerName String: ~
  -RadiusTimeout,-Timeout UInt32: ~
  -SharedSecret String: ~
  -ThrottleLimit Int32: ~
  -Type String:
    required: true
    values:
    - Windows
    - ExternalRadius
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
