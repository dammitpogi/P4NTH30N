description: Creates a script file with metadata
synopses:
- New-ScriptFileInfo [[-Path] <String>] [-Version <String>] [-Author <String>] -Description
  <String> [-Guid <Guid>] [-CompanyName <String>] [-Copyright <String>] [-RequiredModules
  <Object[]>] [-ExternalModuleDependencies <String[]>] [-RequiredScripts <String[]>]
  [-ExternalScriptDependencies <String[]>] [-Tags <String[]>] [-ProjectUri <Uri>]
  [-LicenseUri <Uri>] [-IconUri <Uri>] [-ReleaseNotes <String[]>] [-PrivateData <String>]
  [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Author System.String: ~
  -CompanyName System.String: ~
  -Copyright System.String: ~
  -Description System.String:
    required: true
  -ExternalModuleDependencies System.String[]: ~
  -ExternalScriptDependencies System.String[]: ~
  -Force Switch: ~
  -Guid System.Guid: ~
  -IconUri System.Uri: ~
  -LicenseUri System.Uri: ~
  -PassThru Switch: ~
  -Path System.String: ~
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
