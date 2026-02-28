description: Modifies a display name and description
synopses:
- Set-AdfsAuthenticationProviderWebContent [-DisplayName <String>] [-Description <String>]
  [-UserNotProvisionedErrorMessage <String>] [-PassThru] [[-Locale] <CultureInfo>]
  -Name <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsAuthenticationProviderWebContent [-DisplayName <String>] [-Description <String>]
  [-UserNotProvisionedErrorMessage <String>] [-PassThru] [-TargetWebContent] <AdfsAuthProviderWebContent>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Description String: ~
  -DisplayName String: ~
  -Locale CultureInfo: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -TargetWebContent AdfsAuthProviderWebContent:
    required: true
  -UserNotProvisionedErrorMessage String: ~
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
