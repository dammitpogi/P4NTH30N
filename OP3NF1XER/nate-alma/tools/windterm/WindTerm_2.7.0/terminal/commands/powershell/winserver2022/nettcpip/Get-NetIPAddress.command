description: Gets the IP address configuration
synopses:
- Get-NetIPAddress [[-IPAddress] <String[]>] [-InterfaceIndex <UInt32[]>] [-InterfaceAlias
  <String[]>] [-AddressFamily <AddressFamily[]>] [-Type <Type[]>] [-PrefixLength <Byte[]>]
  [-PrefixOrigin <PrefixOrigin[]>] [-SuffixOrigin <SuffixOrigin[]>] [-AddressState
  <AddressState[]>] [-ValidLifetime <TimeSpan[]>] [-PreferredLifetime <TimeSpan[]>]
  [-SkipAsSource <Boolean[]>] [-AssociatedIPInterface <CimInstance>] [-PolicyStore
  <String>] [-IncludeAllCompartments] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
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
  -AssociatedIPInterface CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -IPAddress,-LocalAddress String[]: ~
  -IncludeAllCompartments Switch: ~
  -InterfaceAlias,-ifAlias String[]: ~
  -InterfaceIndex,-ifIndex UInt32[]: ~
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
