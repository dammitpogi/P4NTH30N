description: Sets properties for the relying party web content objects
synopses:
- Set-AdfsRelyingPartyWebContent [-CertificatePageDescriptionText <String>] [-CompanyName
  <String>] [-ErrorPageDescriptionText <String>] [-ErrorPageGenericErrorMessage <String>]
  [-ErrorPageAuthorizationErrorMessage <String>] [-ErrorPageDeviceAuthenticationErrorMessage
  <String>] [-ErrorPageSupportEmail <String>] [-HelpDeskLink <Uri>] [-HelpDeskLinkText
  <String>] [-HomeLink <Uri>] [-HomeLinkText <String>] [-HomeRealmDiscoveryOtherOrganizationDescriptionText
  <String>] [-HomeRealmDiscoveryPageDescriptionText <String>] [-OrganizationalNameDescriptionText
  <String>] [-PrivacyLink <Uri>] [-PrivacyLinkText <String>] [-SignInPageDescriptionText
  <String>] [-SignInPageAdditionalAuthenticationDescriptionText <String>] [-PassThru]
  [[-Locale] <CultureInfo>] -TargetRelyingPartyName <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-AdfsRelyingPartyWebContent [-CertificatePageDescriptionText <String>] [-CompanyName
  <String>] [-ErrorPageDescriptionText <String>] [-ErrorPageGenericErrorMessage <String>]
  [-ErrorPageAuthorizationErrorMessage <String>] [-ErrorPageDeviceAuthenticationErrorMessage
  <String>] [-ErrorPageSupportEmail <String>] [-HelpDeskLink <Uri>] [-HelpDeskLinkText
  <String>] [-HomeLink <Uri>] [-HomeLinkText <String>] [-HomeRealmDiscoveryOtherOrganizationDescriptionText
  <String>] [-HomeRealmDiscoveryPageDescriptionText <String>] [-OrganizationalNameDescriptionText
  <String>] [-PrivacyLink <Uri>] [-PrivacyLinkText <String>] [-SignInPageDescriptionText
  <String>] [-SignInPageAdditionalAuthenticationDescriptionText <String>] [-PassThru]
  [-TargetRelyingPartyWebContent] <AdfsRelyingPartyWebContent> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CertificatePageDescriptionText String: ~
  -CompanyName String: ~
  -ErrorPageAuthorizationErrorMessage String: ~
  -ErrorPageDescriptionText String: ~
  -ErrorPageDeviceAuthenticationErrorMessage String: ~
  -ErrorPageGenericErrorMessage String: ~
  -ErrorPageSupportEmail String: ~
  -HelpDeskLink Uri: ~
  -HelpDeskLinkText String: ~
  -HomeLink Uri: ~
  -HomeLinkText String: ~
  -HomeRealmDiscoveryOtherOrganizationDescriptionText String: ~
  -HomeRealmDiscoveryPageDescriptionText String: ~
  -Locale CultureInfo: ~
  -OrganizationalNameDescriptionText String: ~
  -PassThru Switch: ~
  -PrivacyLink Uri: ~
  -PrivacyLinkText String: ~
  -SignInPageAdditionalAuthenticationDescriptionText String: ~
  -SignInPageDescriptionText String: ~
  -TargetRelyingPartyName,-Name String:
    required: true
  -TargetRelyingPartyWebContent,-TargetWebContent AdfsRelyingPartyWebContent:
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
