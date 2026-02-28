description: Adds a trust anchor to a DNS server
synopses:
- Add-DnsServerTrustAnchor [-Name] <String> [-KeyProtocol <String>] -Base64Data <String>
  [-ComputerName <String>] [-CryptoAlgorithm] <String> [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerTrustAnchor [-Name] <String> [-ComputerName <String>] [-CryptoAlgorithm]
  <String> [-PassThru] -KeyTag <UInt16> -DigestType <String> -Digest <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerTrustAnchor [-ComputerName <String>] [-PassThru] [-Root] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
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
  -Digest String:
    required: true
  -DigestType String:
    required: true
    values:
    - Sha1
    - Sha256
    - Sha384
  -KeyProtocol String:
    values:
    - DnsSec
  -KeyTag UInt16:
    required: true
  -Name,-TrustAnchorName String:
    required: true
  -PassThru Switch: ~
  -Root Switch:
    required: true
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
