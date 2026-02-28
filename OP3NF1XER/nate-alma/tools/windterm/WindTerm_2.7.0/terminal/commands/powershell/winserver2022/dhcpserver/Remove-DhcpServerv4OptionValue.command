description: Deletes one or more IPv4 option values at the server, scope or reservation
  level, either for the standard IPv4 options or for the specified vendor or user
  class
synopses:
- Remove-DhcpServerv4OptionValue [-VendorClass <String>] [-ComputerName <String>]
  [-OptionId] <UInt32[]> [-UserClass <String>] [[-ScopeId] <IPAddress>] [-ReservedIP
  <IPAddress>] [-PassThru] [-PolicyName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -OptionId UInt32[]:
    required: true
  -PassThru Switch: ~
  -PolicyName String: ~
  -ReservedIP,-IPAddress IPAddress: ~
  -ScopeId IPAddress: ~
  -ThrottleLimit Int32: ~
  -UserClass String: ~
  -VendorClass String: ~
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
