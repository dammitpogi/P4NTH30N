description: Adds a type DS resource record to a DNS zone
synopses:
- Add-DnsServerResourceRecordDS [-Name] <String> [-CryptoAlgorithm] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-Digest] <String> [-DigestType] <String> [-KeyTag] <UInt16>
  [-ComputerName <String>] [-ZoneName] <String> [-PassThru] [-ZoneScope <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AgeRecord Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -CryptoAlgorithm String:
    required: true
    values:
    - RsaSha1
    - RsaSha256
    - RsaSha512
    - RsaSha1NSec3
    - ECDsaP256Sha256
    - ECDsaP384Sha384
  -Digest String:
    required: true
  -DigestType String:
    required: true
    values:
    - Sha1
    - Sha256
    - Sha384
  -KeyTag UInt16:
    required: true
  -Name String:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -TimeToLive TimeSpan: ~
  -WhatIf,-wi Switch: ~
  -ZoneName String:
    required: true
  -ZoneScope String: ~
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
