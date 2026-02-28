description: Modifies DNS Active Directory settings
synopses:
- Set-DnsServerDsSetting [-DirectoryPartitionAutoEnlistInterval <TimeSpan>] [-LazyUpdateInterval
  <UInt32>] [-MinimumBackgroundLoadThreads <UInt32>] [-RemoteReplicationDelay <UInt32>]
  [-ComputerName <String>] [-PollingInterval <UInt32>] [-TombstoneInterval <TimeSpan>]
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DirectoryPartitionAutoEnlistInterval TimeSpan: ~
  -LazyUpdateInterval UInt32: ~
  -MinimumBackgroundLoadThreads UInt32: ~
  -PassThru Switch: ~
  -PollingInterval UInt32: ~
  -RemoteReplicationDelay UInt32: ~
  -ThrottleLimit Int32: ~
  -TombstoneInterval TimeSpan: ~
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
