description: Adds an [Authenticode](/windows-hardware/drivers/install/authenticode)
  signature to a PowerShell script or other file
synopses:
- Set-AuthenticodeSignature [-Certificate] <X509Certificate2> [-IncludeChain <String>]
  [-TimestampServer <String>] [-HashAlgorithm <String>] [-Force] [-FilePath] <String[]>
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AuthenticodeSignature [-Certificate] <X509Certificate2> [-IncludeChain <String>]
  [-TimestampServer <String>] [-HashAlgorithm <String>] [-Force] -LiteralPath <String[]>
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AuthenticodeSignature [-Certificate] <X509Certificate2> [-IncludeChain <String>]
  [-TimestampServer <String>] [-HashAlgorithm <String>] [-Force] -SourcePathOrExtension
  <String[]> -Content <Byte[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Certificate System.Security.Cryptography.X509Certificates.X509Certificate2:
    required: true
  -Content System.Byte[]:
    required: true
  -FilePath System.String[]:
    required: true
  -Force Switch: ~
  -HashAlgorithm System.String: ~
  -IncludeChain System.String: ~
  -LiteralPath,-PSPath System.String[]:
    required: true
  -SourcePathOrExtension System.String[]:
    required: true
  -TimestampServer System.String: ~
  -Confirm,-cf Switch: ~
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
