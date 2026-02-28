description: Enables rollover on the input key
synopses:
- Enable-DnsServerSigningKeyRollover [-ComputerName <String>] [[-RolloverPeriod] <TimeSpan>]
  [[-InitialRolloverOffset] <TimeSpan>] [-Force] [-ZoneName] <String> [-KeyId] <Guid>
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InitialRolloverOffset TimeSpan: ~
  -KeyId Guid:
    required: true
  -PassThru Switch: ~
  -RolloverPeriod TimeSpan: ~
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
  -ZoneName String:
    required: true
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
