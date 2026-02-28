description: Removes web content customization of the authentication provider in the
  user sign-in web pages from AD FS
synopses:
- Remove-AdfsAuthenticationProviderWebContent [[-Locale] <CultureInfo>] -Name <String>
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-AdfsAuthenticationProviderWebContent [-TargetWebContent] <AdfsAuthProviderWebContent>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Locale CultureInfo: ~
  -Name String:
    required: true
  -TargetWebContent AdfsAuthProviderWebContent:
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
