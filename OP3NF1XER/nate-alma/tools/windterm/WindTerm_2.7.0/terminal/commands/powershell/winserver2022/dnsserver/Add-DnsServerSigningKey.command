description: Adds a KSK or ZSK to a signed zone
synopses:
- Add-DnsServerSigningKey [-ZoneName] <String> [[-Type] <String>] [[-CryptoAlgorithm]
  <String>] [-ComputerName <String>] [[-KeyLength] <UInt32>] [-InitialRolloverOffset
  <TimeSpan>] [-DnsKeySignatureValidityPeriod <TimeSpan>] [-DSSignatureValidityPeriod
  <TimeSpan>] [-ZoneSignatureValidityPeriod <TimeSpan>] [-RolloverPeriod <TimeSpan>]
  [-ActiveKey <String>] [-StandbyKey <String>] [-NextKey <String>] [-KeyStorageProvider
  <String>] [-StoreKeysInAD <Boolean>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ActiveKey String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -CryptoAlgorithm String:
    values:
    - RsaSha1
    - RsaSha256
    - RsaSha512
    - RsaSha1NSec3
    - ECDsaP256Sha256
    - ECDsaP384Sha384
  -DSSignatureValidityPeriod TimeSpan: ~
  -DnsKeySignatureValidityPeriod TimeSpan: ~
  -InitialRolloverOffset TimeSpan: ~
  -KeyLength UInt32: ~
  -KeyStorageProvider String: ~
  -NextKey String: ~
  -PassThru Switch: ~
  -RolloverPeriod TimeSpan: ~
  -StandbyKey String: ~
  -StoreKeysInAD Boolean: ~
  -ThrottleLimit Int32: ~
  -Type,-KeyType String:
    values:
    - KeySigningKey
    - ZoneSigningKey
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
