description: Adds an IPv6 scope to the DHCP server service with the specified parameters
synopses:
- Add-DhcpServerv6Scope [-ValidLifeTime <TimeSpan>] [-ComputerName <String>] [-Prefix]
  <IPAddress> [-Name] <String> [-Description <String>] [-State <String>] [-Preference
  <UInt16>] [-PreferredLifetime <TimeSpan>] [-T1 <TimeSpan>] [-T2 <TimeSpan>] [-PassThru]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -Preference UInt16: ~
  -PreferredLifetime TimeSpan: ~
  -Prefix IPAddress:
    required: true
  -State String:
    values:
    - Active
    - Inactive
  -T1 TimeSpan: ~
  -T2 TimeSpan: ~
  -ThrottleLimit Int32: ~
  -ValidLifeTime TimeSpan: ~
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
