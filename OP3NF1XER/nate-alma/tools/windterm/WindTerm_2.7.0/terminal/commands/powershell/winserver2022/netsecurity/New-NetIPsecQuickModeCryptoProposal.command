description: Creates a quick mode cryptographic proposal that specifies a suite of
  cryptographic protocols to offer in IPsec quick mode negotiations with other computers
synopses:
- New-NetIPsecQuickModeCryptoProposal [-Encryption <EncryptionAlgorithm>] [-AHHash
  <HashAlgorithm>] [-ESPHash <HashAlgorithm>] [-MaxKiloBytes <UInt64>] [-MaxMinutes
  <UInt64>] [-Encapsulation <IPsecEncapsulation>] [<CommonParameters>]
options:
  -AHHash HashAlgorithm:
    values:
    - None
    - MD5
    - SHA1
    - SHA256
    - SHA384
    - AESGMAC128
    - AESGMAC192
    - AESGMAC256
  -ESPHash HashAlgorithm:
    values:
    - None
    - MD5
    - SHA1
    - SHA256
    - SHA384
    - AESGMAC128
    - AESGMAC192
    - AESGMAC256
  -Encapsulation IPsecEncapsulation:
    values:
    - None
    - AH
    - ESP
  -Encryption EncryptionAlgorithm:
    values:
    - None
    - DES
    - DES3
    - AES128
    - AES192
    - AES256
    - AESGCM128
    - AESGCM192
    - AESGCM256
  -MaxKiloBytes UInt64: ~
  -MaxMinutes UInt64: ~
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
