description: Changes settings of a signing key
synopses:
- Set-DnsServerSigningKey [-ZoneName] <String> [-RolloverPeriod <TimeSpan>] [-DnsKeySignatureValidityPeriod
  <TimeSpan>] [-DSSignatureValidityPeriod <TimeSpan>] [-ZoneSignatureValidityPeriod
  <TimeSpan>] [-KeyId] <Guid> [-NextRolloverAction <String>] [-ComputerName <String>]
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DSSignatureValidityPeriod TimeSpan: ~
  -DnsKeySignatureValidityPeriod TimeSpan: ~
  -KeyId Guid:
    required: true
  -NextRolloverAction String:
    values:
    - Normal
    - RevokeStandby
    - Retire
  -PassThru Switch: ~
  -RolloverPeriod TimeSpan: ~
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
  -ZoneName String:
    required: true
  -ZoneSignatureValidityPeriod TimeSpan: ~
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
