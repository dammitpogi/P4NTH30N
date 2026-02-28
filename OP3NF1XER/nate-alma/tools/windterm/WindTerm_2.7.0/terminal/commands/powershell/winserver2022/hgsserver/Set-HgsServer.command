description: Sets the Host Guardian Service server configuration
synopses:
- Set-HgsServer [-Http] [-Https] [-HttpPort <UInt16>] [-HttpsPort <UInt16>] [-HttpsCertificateThumbprint
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsServer [-Http] [-Https] [-HttpPort <UInt16>] [-HttpsPort <UInt16>] [-HttpsCertificatePath
  <String>] [-HttpsCertificatePassword <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsServer [-Http] [-HttpPort <UInt16>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsServer [-Https] [-HttpPort <UInt16>] [-HttpsPort <UInt16>] [-HttpsCertificateThumbprint
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsServer [-Https] [-HttpsPort <UInt16>] [-HttpsCertificatePath <String>] [-HttpsCertificatePassword
  <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsServer [-TrustActiveDirectory] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsServer [-TrustTpm] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsServer [-UpdateMemoryLimit] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Http Switch:
    required: true
  -HttpPort UInt16: ~
  -Https Switch:
    required: true
  -HttpsCertificatePassword SecureString: ~
  -HttpsCertificatePath String: ~
  -HttpsCertificateThumbprint String: ~
  -HttpsPort UInt16: ~
  -TrustActiveDirectory Switch:
    required: true
  -TrustTpm Switch:
    required: true
  -UpdateMemoryLimit Switch:
    required: true
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
