description: Sets the enabled state for inbox and RADIUS accounting for both external
  RADIUS and Windows accounting and configures the settings when enabled
synopses:
- Set-RemoteAccessAccounting [-ComputerName <String>] [-PassThru] [-RadiusServer <String>]
  [-SharedSecret <String>] [-RadiusPort <UInt16>] [-RadiusScore <Byte>] [-RadiusTimeout
  <UInt32>] [-AccountingOnOffMsg <String>] [-EnableAccountingType] <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-RemoteAccessAccounting -DisableAccountingType <String> [-ComputerName <String>]
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AccountingOnOffMsg String:
    values:
    - Enabled
    - Disabled
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DisableAccountingType String:
    required: true
    values:
    - Inbox
    - ExternalRadius
  -EnableAccountingType String:
    required: true
    values:
    - Inbox
    - ExternalRadius
  -PassThru Switch: ~
  -RadiusPort,-Port UInt16: ~
  -RadiusScore,-Score Byte: ~
  -RadiusServer,-ServerName String: ~
  -RadiusTimeout,-Timeout UInt32: ~
  -SharedSecret String: ~
  -ThrottleLimit Int32: ~
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
