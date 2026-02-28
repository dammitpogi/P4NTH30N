description: Sets an IPv4 option value at the server, scope, or reservation level
synopses:
- Set-DhcpServerv4OptionValue [-PolicyName <String>] [-PassThru] [-Force] [-ReservedIP
  <IPAddress>] [[-ScopeId] <IPAddress>] [-UserClass <String>] [-ComputerName <String>]
  [-VendorClass <String>] [-Value] <String[]> [-OptionId] <UInt32> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DhcpServerv4OptionValue [-PolicyName <String>] [-PassThru] [-Force] [-DnsDomain
  <String>] [-DnsServer <IPAddress[]>] [-ReservedIP <IPAddress>] [-Router <IPAddress[]>]
  [[-ScopeId] <IPAddress>] [-UserClass <String>] [-WinsServer <IPAddress[]>] [-Wpad
  <String>] [-ComputerName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DnsDomain String: ~
  -DnsServer IPAddress[]: ~
  -Force Switch: ~
  -OptionId UInt32:
    required: true
  -PassThru Switch: ~
  -PolicyName String: ~
  -ReservedIP,-IPAddress IPAddress: ~
  -Router IPAddress[]: ~
  -ScopeId IPAddress: ~
  -ThrottleLimit Int32: ~
  -UserClass String: ~
  -Value String[]:
    required: true
  -VendorClass String: ~
  -WhatIf,-wi Switch: ~
  -WinsServer IPAddress[]: ~
  -Wpad String: ~
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
