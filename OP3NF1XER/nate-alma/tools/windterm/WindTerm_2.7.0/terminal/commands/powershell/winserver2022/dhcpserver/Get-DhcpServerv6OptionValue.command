description: Returns the IPv6 option values for one or more IPv6 options either for
  a specific reserved IP, scope or, server level
synopses:
- Get-DhcpServerv6OptionValue [-ComputerName <String>] [-VendorClass <String>] [[-Prefix]
  <IPAddress>] [-ReservedIP <IPAddress>] [-UserClass <String>] [[-OptionId] <UInt32[]>]
  [-All] [-Brief] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -Brief Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -OptionId UInt32[]: ~
  -Prefix IPAddress: ~
  -ReservedIP,-IPAddress IPAddress: ~
  -ThrottleLimit Int32: ~
  -UserClass String: ~
  -VendorClass String: ~
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
