description: Exports a certificate or a PFXData object to a Personal Information Exchange
  (PFX) file
synopses:
- Export-PfxCertificate [-NoProperties] [-NoClobber] [-Force] [-CryptoAlgorithmOption
  <CryptoAlgorithmOptions>] [-ChainOption <ExportChainOption>] [-ProtectTo <String[]>]
  [-Password <SecureString>] [-FilePath] <String> [-PFXData] <PfxData> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Export-PfxCertificate [-NoProperties] [-NoClobber] [-Force] [-CryptoAlgorithmOption
  <CryptoAlgorithmOptions>] [-ChainOption <ExportChainOption>] [-ProtectTo <String[]>]
  [-Password <SecureString>] [-FilePath] <String> [-Cert] <Certificate> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Cert,-PsPath Certificate:
    required: true
  -ChainOption ExportChainOption:
    values:
    - BuildChain
    - EndEntityCertOnly
    - PfxDataOnly
  -Confirm,-cf Switch: ~
  -CryptoAlgorithmOption CryptoAlgorithmOptions:
    values:
    - TripleDES_SHA1
    - AES256_SHA256
  -FilePath String:
    required: true
  -Force Switch: ~
  -NoClobber Switch: ~
  -NoProperties Switch: ~
  -PFXData PfxData:
    required: true
  -Password SecureString: ~
  -ProtectTo String[]: ~
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
