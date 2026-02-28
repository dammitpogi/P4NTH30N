description: Publishes a specified module from the local computer to an online gallery
synopses:
- Publish-Module -Name <String> [-RequiredVersion <String>] [-NuGetApiKey <String>]
  [-Repository <String>] [-Credential <PSCredential>] [-FormatVersion <Version>] [-ReleaseNotes
  <String[]>] [-Tags <String[]>] [-LicenseUri <Uri>] [-IconUri <Uri>] [-ProjectUri
  <Uri>] [-Exclude <String[]>] [-Force] [-AllowPrerelease] [-SkipAutomaticTags] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Publish-Module -Path <String> [-NuGetApiKey <String>] [-Repository <String>] [-Credential
  <PSCredential>] [-FormatVersion <Version>] [-ReleaseNotes <String[]>] [-Tags <String[]>]
  [-LicenseUri <Uri>] [-IconUri <Uri>] [-ProjectUri <Uri>] [-Force] [-SkipAutomaticTags]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowPrerelease Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Force Switch: ~
  -FormatVersion System.Version:
    values:
    - '2.0'
  -IconUri System.Uri: ~
  -LicenseUri System.Uri: ~
  -Name System.String:
    required: true
  -NuGetApiKey System.String: ~
  -Path System.String:
    required: true
  -ProjectUri System.Uri: ~
  -ReleaseNotes System.String[]: ~
  -Repository System.String: ~
  -RequiredVersion System.String: ~
  -SkipAutomaticTags Switch: ~
  -Tags System.String[]: ~
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
