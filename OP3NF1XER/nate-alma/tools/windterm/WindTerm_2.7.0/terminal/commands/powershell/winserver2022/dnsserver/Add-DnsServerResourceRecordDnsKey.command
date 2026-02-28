description: Adds a type DNSKEY resource record to a DNS zone
synopses:
- Add-DnsServerResourceRecordDnsKey [-Name] <String> [-CryptoAlgorithm] <String> [-ZoneName]
  <String> [-TimeToLive <TimeSpan>] [-AgeRecord] [-Base64Data] <String> [-KeyProtocol
  <String>] [-ComputerName <String>] [-SecureEntryPoint] [-ZoneKey] [-PassThru] [-ZoneScope
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AgeRecord Switch: ~
  -AsJob Switch: ~
  -Base64Data String:
    required: true
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
  -KeyProtocol String:
    values:
    - DnsSec
  -Name String:
    required: true
  -PassThru Switch: ~
  -SecureEntryPoint Switch: ~
  -ThrottleLimit Int32: ~
  -TimeToLive TimeSpan: ~
  -WhatIf,-wi Switch: ~
  -ZoneKey Switch: ~
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
