description: Updates information for a script
synopses:
- Update-ScriptFileInfo [-Path] <String> [-Version <String>] [-Author <String>] [-Guid
  <Guid>] [-Description <String>] [-CompanyName <String>] [-Copyright <String>] [-RequiredModules
  <Object[]>] [-ExternalModuleDependencies <String[]>] [-RequiredScripts <String[]>]
  [-ExternalScriptDependencies <String[]>] [-Tags <String[]>] [-ProjectUri <Uri>]
  [-LicenseUri <Uri>] [-IconUri <Uri>] [-ReleaseNotes <String[]>] [-PrivateData <String>]
  [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Update-ScriptFileInfo [-LiteralPath] <String> [-Version <String>] [-Author <String>]
  [-Guid <Guid>] [-Description <String>] [-CompanyName <String>] [-Copyright <String>]
  [-RequiredModules <Object[]>] [-ExternalModuleDependencies <String[]>] [-RequiredScripts
  <String[]>] [-ExternalScriptDependencies <String[]>] [-Tags <String[]>] [-ProjectUri
  <Uri>] [-LicenseUri <Uri>] [-IconUri <Uri>] [-ReleaseNotes <String[]>] [-PrivateData
  <String>] [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Author System.String: ~
  -CompanyName System.String: ~
  -Copyright System.String: ~
  -Description System.String: ~
  -ExternalModuleDependencies System.String[]: ~
  -ExternalScriptDependencies System.String[]: ~
  -Force Switch: ~
  -Guid System.Guid: ~
  -IconUri System.Uri: ~
  -LicenseUri System.Uri: ~
  -LiteralPath,-PSPath System.String:
    required: true
  -PassThru Switch: ~
  -Path System.String:
    required: true
  -PrivateData System.String: ~
  -ProjectUri System.Uri: ~
  -ReleaseNotes System.String[]: ~
  -RequiredModules System.Object[]: ~
  -RequiredScripts System.String[]: ~
  -Tags System.String[]: ~
  -Version System.String: ~
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
