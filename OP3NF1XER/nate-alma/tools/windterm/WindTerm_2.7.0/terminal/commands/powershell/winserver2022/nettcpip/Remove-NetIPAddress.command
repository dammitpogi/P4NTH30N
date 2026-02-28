description: Removes an IP address and its configuration
synopses:
- Remove-NetIPAddress [[-IPAddress] <String[]>] [-InterfaceIndex <UInt32[]>] [-InterfaceAlias
  <String[]>] [-AddressFamily <AddressFamily[]>] [-Type <Type[]>] [-PrefixLength <Byte[]>]
  [-PrefixOrigin <PrefixOrigin[]>] [-SuffixOrigin <SuffixOrigin[]>] [-AddressState
  <AddressState[]>] [-ValidLifetime <TimeSpan[]>] [-PreferredLifetime <TimeSpan[]>]
  [-SkipAsSource <Boolean[]>] [-PolicyStore <String>] [-DefaultGateway <String>] [-IncludeAllCompartments]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-NetIPAddress -InputObject <CimInstance[]> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressFamily AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AddressState AddressState[]:
    values:
    - Invalid
    - Tentative
    - Duplicate
    - Deprecated
    - Preferred
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DefaultGateway String: ~
  -IPAddress,-LocalAddress String[]: ~
  -IncludeAllCompartments Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias,-ifAlias String[]: ~
  -InterfaceIndex,-ifIndex UInt32[]: ~
  -PassThru Switch: ~
  -PolicyStore String: ~
  -PreferredLifetime TimeSpan[]: ~
  -PrefixLength Byte[]: ~
  -PrefixOrigin PrefixOrigin[]:
    values:
    - Other
    - Manual
    - WellKnown
    - Dhcp
    - RouterAdvertisement
  -SkipAsSource Boolean[]: ~
  -SuffixOrigin SuffixOrigin[]:
    values:
    - Other
    - Manual
    - WellKnown
    - Dhcp
    - Link
    - Random
  -ThrottleLimit Int32: ~
  -Type Type[]:
    values:
    - Unicast
    - Anycast
  -ValidLifetime TimeSpan[]: ~
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
