description: Creates a local claims provider trust
synopses:
- Add-AdfsLocalClaimsProviderTrust -Name <String> -Identifier <String> [-AcceptanceTransformRules
  <String>] [-AcceptanceTransformRulesFile <String>] [-Enabled <Boolean>] [-Notes
  <String>] [-OrganizationalAccountSuffix <String[]>] [-Force] [-Type <String>] [-PassThru]
  [-WhatIf] [-Confirm] -LdapServerConnection <LdapServerConnection[]> -UserObjectClass
  <String> -UserContainer <String> -AnchorClaimLdapAttribute <String> -AnchorClaimType
  <String> [-LdapAuthenticationMethod <LdapAuthenticationMethod>] [-LdapAttributeToClaimMapping
  <LdapAttributeToClaimMapping[]>] [<CommonParameters>]
options:
  -AcceptanceTransformRules String: ~
  -AcceptanceTransformRulesFile String: ~
  -AnchorClaimLdapAttribute String:
    required: true
  -AnchorClaimType String:
    required: true
  -Enabled Boolean: ~
  -Force Switch: ~
  -Identifier String:
    required: true
  -LdapAttributeToClaimMapping LdapAttributeToClaimMapping[]: ~
  -LdapAuthenticationMethod LdapAuthenticationMethod:
    values:
    - Basic
    - Kerberos
    - Negotiate
  -LdapServerConnection LdapServerConnection[]:
    required: true
  -Name String:
    required: true
  -Notes String: ~
  -OrganizationalAccountSuffix String[]: ~
  -PassThru Switch: ~
  -Type String: ~
  -UserContainer String:
    required: true
  -UserObjectClass String:
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
