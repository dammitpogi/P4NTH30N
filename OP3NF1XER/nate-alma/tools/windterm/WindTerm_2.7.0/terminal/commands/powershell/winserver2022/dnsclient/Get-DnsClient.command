description: Gets details of the network interfaces configured on a specified computer
synopses:
- Get-DnsClient [-InterfaceIndex <UInt32[]>] [[-InterfaceAlias] <String[]>] [-ConnectionSpecificSuffix
  <String[]>] [-RegisterThisConnectionsAddress <Boolean[]>] [-UseSuffixWhenRegistering
  <Boolean[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ConnectionSpecificSuffix,-Suffix String[]: ~
  -InterfaceAlias String[]: ~
  -InterfaceIndex UInt32[]: ~
  -RegisterThisConnectionsAddress Boolean[]: ~
  -ThrottleLimit Int32: ~
  -UseSuffixWhenRegistering Boolean[]: ~
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
