description: Modifies cache settings for a DNS server
synopses:
- Set-DnsServerCache [-StoreEmptyAuthenticationResponse <Boolean>] [-MaxKBSize <UInt32>]
  [-PollutionProtection <Boolean>] [-ComputerName <String>] [-LockingPercent <UInt32>]
  [-MaxNegativeTtl <TimeSpan>] [-MaxTtl <TimeSpan>] [-PassThru] [-IgnorePolicies <Boolean>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -IgnorePolicies Boolean: ~
  -LockingPercent UInt32: ~
  -MaxKBSize UInt32: ~
  -MaxNegativeTtl TimeSpan: ~
  -MaxTtl TimeSpan: ~
  -PassThru Switch: ~
  -PollutionProtection Boolean: ~
  -StoreEmptyAuthenticationResponse Boolean: ~
  -ThrottleLimit Int32: ~
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
