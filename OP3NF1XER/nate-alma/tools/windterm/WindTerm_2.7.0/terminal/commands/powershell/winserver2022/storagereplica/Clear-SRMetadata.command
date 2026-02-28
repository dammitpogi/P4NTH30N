description: Removes unreferenced Storage Replica metadata
synopses:
- Clear-SRMetadata [[-ComputerName] <String>] [-NoRestart] [-Force] [-Name] <String>
  [-Logs] [-Partition] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Clear-SRMetadata [[-ComputerName] <String>] [-AllConfiguration] [-AllLogs] [-AllPartitions]
  [-NoRestart] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllConfiguration,-AC Switch: ~
  -AllLogs,-AL Switch: ~
  -AllPartitions,-AP Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -Force,-F Switch: ~
  -Logs,-LO Switch: ~
  -Name,-N String:
    required: true
  -NoRestart,-NR Switch: ~
  -Partition,-PA Switch: ~
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
