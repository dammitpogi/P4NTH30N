description: Sets DNS server addresses associated with the TCP/IP properties on an
  interface
synopses:
- Set-DnsClientServerAddress [-InterfaceAlias] <String[]> [-ServerAddresses <String[]>]
  [-Validate] [-ResetServerAddresses] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsClientServerAddress -InterfaceIndex <UInt32[]> [-ServerAddresses <String[]>]
  [-Validate] [-ResetServerAddresses] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsClientServerAddress -InputObject <CimInstance[]> [-ServerAddresses <String[]>]
  [-Validate] [-ResetServerAddresses] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias String[]:
    required: true
  -InterfaceIndex UInt32[]:
    required: true
  -PassThru Switch: ~
  -ResetServerAddresses,-ResetAddresses Switch: ~
  -ServerAddresses,-Addresses String[]: ~
  -ThrottleLimit Int32: ~
  -Validate Switch: ~
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
