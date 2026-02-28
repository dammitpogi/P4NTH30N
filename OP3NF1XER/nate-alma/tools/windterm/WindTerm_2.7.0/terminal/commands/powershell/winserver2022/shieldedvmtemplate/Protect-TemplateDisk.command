description: Prepares a signed template disk (.VHDX) which can be used to provision
  new shielded virtual machines
synopses:
- Protect-TemplateDisk -Path <String> -TemplateName <String> -Version <Version> -Certificate
  <X509Certificate2> [-ProtectedTemplateTargetDiskType <ProtectedTemplateTargetDiskType>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Protect-TemplateDisk -Path <String> -PopulateFrom <String> [-TemplateName <String>]
  [-Version <Version>] -Certificate <X509Certificate2> [-ProtectedTemplateTargetDiskType
  <ProtectedTemplateTargetDiskType>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Protect-TemplateDisk -Path <String> [-DiskIsAlreadySpecialized] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Certificate X509Certificate2:
    required: true
  -DiskIsAlreadySpecialized Switch: ~
  -Path String:
    required: true
  -PopulateFrom String:
    required: true
  -ProtectedTemplateTargetDiskType ProtectedTemplateTargetDiskType:
    values:
    - MicrosoftWindows
    - PreprocessedLinux
  -TemplateName String:
    required: true
  -Version Version:
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
