description: Changes settings for DNSSEC for a zone
synopses:
- Set-DnsServerDnsSecZoneSetting [-ZoneName] <String> [[-DenialOfExistence] <String>]
  [-NSec3HashAlgorithm <String>] [-NSec3Iterations <UInt16>] [-NSec3OptOut <Boolean>]
  [-NSec3RandomSaltLength <Byte>] [-NSec3UserSalt <String>] [-DistributeTrustAnchor
  <String[]>] [-EnableRfc5011KeyRollover <Boolean>] [-DSRecordGenerationAlgorithm
  <String[]>] [-DSRecordSetTtl <TimeSpan>] [-DnsKeyRecordSetTtl <TimeSpan>] [-SignatureInceptionOffset
  <TimeSpan>] [-SecureDelegationPollingPeriod <TimeSpan>] [-PropagationTime <TimeSpan>]
  [-ParentHasSecureDelegation <Boolean>] [-ComputerName <String>] [-PassThru] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsServerDnsSecZoneSetting [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [[-InputObject] <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DSRecordGenerationAlgorithm String[]:
    values:
    - None
    - Sha1
    - Sha256
    - Sha384
  -DSRecordSetTtl TimeSpan: ~
  -DenialOfExistence String:
    values:
    - NSec
    - NSec3
  -DistributeTrustAnchor String[]:
    values:
    - None
    - DnsKey
  -DnsKeyRecordSetTtl TimeSpan: ~
  -EnableRfc5011KeyRollover Boolean: ~
  -InputObject CimInstance: ~
  -NSec3HashAlgorithm String:
    values:
    - RsaSha1
  -NSec3Iterations UInt16: ~
  -NSec3OptOut Boolean: ~
  -NSec3RandomSaltLength Byte: ~
  -NSec3UserSalt String: ~
  -ParentHasSecureDelegation Boolean: ~
  -PassThru Switch: ~
  -PropagationTime TimeSpan: ~
  -SecureDelegationPollingPeriod TimeSpan: ~
  -SignatureInceptionOffset TimeSpan: ~
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
