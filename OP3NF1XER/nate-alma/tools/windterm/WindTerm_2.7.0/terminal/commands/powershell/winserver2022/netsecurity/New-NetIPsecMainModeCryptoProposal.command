description: Creates a main mode cryptographic proposal that specifies a suite of
  cryptographic protocols to offer in IPsec main mode negotiations with other computers
synopses:
- New-NetIPsecMainModeCryptoProposal [-Encryption <EncryptionAlgorithm>] [-KeyExchange
  <DiffieHellmanGroup>] [-Hash <HashAlgorithm>] [<CommonParameters>]
options:
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
  -Hash HashAlgorithm:
    values:
    - None
    - MD5
    - SHA1
    - SHA256
    - SHA384
    - AESGMAC128
    - AESGMAC192
    - AESGMAC256
  -KeyExchange DiffieHellmanGroup:
    values:
    - None
    - DH1
    - DH2
    - DH14
    - DH19
    - DH20
    - DH24
    - SameAsMainMode
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
