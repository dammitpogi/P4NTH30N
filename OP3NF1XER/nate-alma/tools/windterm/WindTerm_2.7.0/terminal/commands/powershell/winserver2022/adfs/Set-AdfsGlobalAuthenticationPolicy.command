description: Modifies the AD FS global policy
synopses:
- Set-AdfsGlobalAuthenticationPolicy [-AdditionalAuthenticationProvider <String[]>]
  [-DeviceAuthenticationEnabled <Boolean>] [-DeviceAuthenticationMethod <DeviceAuthenticationMethod>]
  [-AllowDeviceAuthAsPrimaryForDomainJoinedDevices <Boolean>] [-PrimaryExtranetAuthenticationProvider
  <String[]>] [-PrimaryIntranetAuthenticationProvider <String[]>] [-WindowsIntegratedFallbackEnabled
  <Boolean>] [-ClientAuthenticationMethods <ClientAuthenticationMethod>] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AdditionalAuthenticationProvider String[]: ~
  -AllowDeviceAuthAsPrimaryForDomainJoinedDevices Boolean: ~
  -ClientAuthenticationMethods ClientAuthenticationMethod:
    values:
    - None
    - ClientSecretPostAuthentication
    - ClientSecretBasicAuthentication
    - PrivateKeyJWTBearerAuthentication
    - WindowsIntegratedAuthentication
  -DeviceAuthenticationEnabled Boolean: ~
  -DeviceAuthenticationMethod DeviceAuthenticationMethod:
    values:
    - All
    - ClientTLS
    - SignedToken
    - PKeyAuth
  -PassThru Switch: ~
  -PrimaryExtranetAuthenticationProvider String[]: ~
  -PrimaryIntranetAuthenticationProvider String[]: ~
  -WindowsIntegratedFallbackEnabled Boolean: ~
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
