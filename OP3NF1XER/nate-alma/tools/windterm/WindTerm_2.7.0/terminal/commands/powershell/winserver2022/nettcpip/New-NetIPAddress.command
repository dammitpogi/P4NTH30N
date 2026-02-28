description: Creates and configures an IP address
synopses:
- New-NetIPAddress [-IPAddress] <String> -InterfaceAlias <String> [-DefaultGateway
  <String>] [-AddressFamily <AddressFamily>] [-Type <Type>] [-PrefixLength <Byte>]
  [-ValidLifetime <TimeSpan>] [-PreferredLifetime <TimeSpan>] [-SkipAsSource <Boolean>]
  [-PolicyStore <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-NetIPAddress [-IPAddress] <String> [-DefaultGateway <String>] [-AddressFamily
  <AddressFamily>] [-Type <Type>] [-PrefixLength <Byte>] [-ValidLifetime <TimeSpan>]
  [-PreferredLifetime <TimeSpan>] [-SkipAsSource <Boolean>] [-PolicyStore <String>]
  -InterfaceIndex <UInt32> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressFamily AddressFamily:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DefaultGateway String: ~
  -IPAddress,-LocalAddress String:
    required: true
  -InterfaceAlias,-ifAlias String:
    required: true
  -InterfaceIndex,-ifIndex UInt32:
    required: true
  -PolicyStore String: ~
  -PreferredLifetime TimeSpan: ~
  -PrefixLength Byte: ~
  -SkipAsSource Boolean: ~
  -ThrottleLimit Int32: ~
  -Type Type:
    values:
    - Unicast
    - Anycast
  -ValidLifetime TimeSpan: ~
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
