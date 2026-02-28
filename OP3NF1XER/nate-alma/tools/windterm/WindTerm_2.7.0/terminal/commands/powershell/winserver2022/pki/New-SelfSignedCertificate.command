description: Creates a new self-signed certificate for testing purposes
synopses:
- New-SelfSignedCertificate [-SecurityDescriptor <FileSecurity>] [-TextExtension <String[]>]
  [-Extension <X509Extension[]>] [-HardwareKeyUsage <HardwareKeyUsage[]>] [-KeyUsageProperty
  <KeyUsageProperty[]>] [-KeyUsage <KeyUsage[]>] [-KeyProtection <KeyProtection[]>]
  [-KeyExportPolicy <KeyExportPolicy[]>] [-KeyLength <Int32>] [-KeyAlgorithm <String>]
  [-SmimeCapabilities] [-ExistingKey] [-KeyLocation <String>] [-SignerReader <String>]
  [-Reader <String>] [-SignerPin <SecureString>] [-Pin <SecureString>] [-KeyDescription
  <String>] [-KeyFriendlyName <String>] [-Container <String>] [-Provider <String>]
  [-CurveExport <CurveParametersExportType>] [-KeySpec <KeySpec>] [-Type <CertificateType>]
  [-FriendlyName <String>] [-NotAfter <DateTime>] [-NotBefore <DateTime>] [-SerialNumber
  <String>] [-Subject <String>] [-DnsName <String[]>] [-SuppressOid <String[]>] [-HashAlgorithm
  <String>] [-AlternateSignatureAlgorithm] [-TestRoot] [-Signer <Certificate>] [-CloneCert
  <Certificate>] [-CertStoreLocation <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AlternateSignatureAlgorithm Switch: ~
  -CertStoreLocation String: ~
  -CloneCert Certificate: ~
  -Confirm,-cf Switch: ~
  -Container String: ~
  -CurveExport CurveParametersExportType:
    values:
    - None
    - CurveParameters
    - CurveName
  -DnsName String[]: ~
  -ExistingKey Switch: ~
  -Extension X509Extension[]: ~
  -FriendlyName String: ~
  -HardwareKeyUsage HardwareKeyUsage[]:
    values:
    - None
    - SignatureKey
    - EncryptionKey
    - GenericKey
    - StorageKey
    - IdentityKey
  -HashAlgorithm String: ~
  -KeyAlgorithm String: ~
  -KeyDescription String: ~
  -KeyExportPolicy KeyExportPolicy[]:
    values:
    - NonExportable
    - ExportableEncrypted
    - Exportable
  -KeyFriendlyName String: ~
  -KeyLength Int32: ~
  -KeyLocation String: ~
  -KeyProtection KeyProtection[]:
    values:
    - None
    - Protect
    - ProtectHigh
    - ProtectFingerPrint
  -KeySpec KeySpec:
    values:
    - None
    - KeyExchange
    - Signature
  -KeyUsage KeyUsage[]:
    values:
    - None
    - EncipherOnly
    - CRLSign
    - CertSign
    - KeyAgreement
    - DataEncipherment
    - KeyEncipherment
    - NonRepudiation
    - DigitalSignature
    - DecipherOnly
  -KeyUsageProperty KeyUsageProperty[]:
    values:
    - None
    - Decrypt
    - Sign
    - KeyAgreement
    - All
  -NotAfter DateTime: ~
  -NotBefore DateTime: ~
  -Pin SecureString: ~
  -Provider String: ~
  -Reader String: ~
  -SecurityDescriptor FileSecurity: ~
  -SerialNumber String: ~
  -Signer Certificate: ~
  -SignerPin SecureString: ~
  -SignerReader String: ~
  -SmimeCapabilities Switch: ~
  -Subject String: ~
  -SuppressOid String[]: ~
  -TestRoot Switch: ~
  -TextExtension String[]: ~
  -Type CertificateType:
    values:
    - Custom
    - CodeSigningCert
    - DocumentEncryptionCert
    - SSLServerAuthentication
    - DocumentEncryptionCertLegacyCsp
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
