description: Returns the IPv4 option values for IPv4 options at the server, scope,
  or reservation level
synopses:
- Get-DhcpServerv4OptionValue [-VendorClass <String>] [-ComputerName <String>] [[-ScopeId]
  <IPAddress>] [-ReservedIP <IPAddress>] [[-OptionId] <UInt32[]>] [-UserClass <String>]
  [-All] [-Brief] [-PolicyName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -Brief Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -OptionId UInt32[]: ~
  -PolicyName String: ~
  -ReservedIP,-IPAddress IPAddress: ~
  -ScopeId IPAddress: ~
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
