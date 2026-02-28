description: Sets an IPv6 option value at the server, scope, or reservation level
synopses:
- Set-DhcpServerv6OptionValue [-PassThru] [-Force] [[-Prefix] <IPAddress>] [-UserClass
  <String>] [-ComputerName <String>] [-ReservedIP <IPAddress>] [-Value] <String[]>
  [-OptionId] <UInt32> [-VendorClass <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DhcpServerv6OptionValue [-PassThru] [-Force] [[-Prefix] <IPAddress>] [-UserClass
  <String>] [-DnsServer <IPAddress[]>] [-DomainSearchList <String[]>] [-InfoRefreshTime
  <UInt32>] [-ComputerName <String>] [-ReservedIP <IPAddress>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DnsServer IPAddress[]: ~
  -DomainSearchList String[]: ~
  -Force Switch: ~
  -InfoRefreshTime UInt32: ~
  -OptionId UInt32:
    required: true
  -PassThru Switch: ~
  -Prefix IPAddress: ~
  -ReservedIP,-IPAddress IPAddress: ~
  -ThrottleLimit Int32: ~
  -UserClass String: ~
  -Value String[]:
    required: true
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
