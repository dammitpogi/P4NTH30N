description: Creates a new Active Directory managed service account or group managed
  service account object
synopses:
- New-ADServiceAccount [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-AuthenticationPolicy <ADAuthenticationPolicy>] [-AuthenticationPolicySilo
  <ADAuthenticationPolicySilo>] [-AuthType <ADAuthType>] [-Certificates <String[]>]
  [-CompoundIdentitySupported <Boolean>] [-Credential <PSCredential>] [-Description
  <String>] [-DisplayName <String>] -DNSHostName <String> [-Enabled <Boolean>] [-HomePage
  <String>] [-Instance <ADServiceAccount>] [-KerberosEncryptionType <ADKerberosEncryptionType>]
  [-ManagedPasswordIntervalInDays <Int32>] [-Name] <String> [-OtherAttributes <Hashtable>]
  [-PassThru] [-Path <String>] [-PrincipalsAllowedToDelegateToAccount <ADPrincipal[]>]
  [-PrincipalsAllowedToRetrieveManagedPassword <ADPrincipal[]>] [-SamAccountName <String>]
  [-Server <String>] [-ServicePrincipalNames <String[]>] [-TrustedForDelegation <Boolean>]
  [<CommonParameters>]
- New-ADServiceAccount [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-AccountPassword <SecureString>] [-AuthenticationPolicy <ADAuthenticationPolicy>]
  [-AuthenticationPolicySilo <ADAuthenticationPolicySilo>] [-AuthType <ADAuthType>]
  [-Certificates <String[]>] [-Credential <PSCredential>] [-Description <String>]
  [-DisplayName <String>] [-Enabled <Boolean>] [-HomePage <String>] [-Instance <ADServiceAccount>]
  [-KerberosEncryptionType <ADKerberosEncryptionType>] [-Name] <String> [-OtherAttributes
  <Hashtable>] [-PassThru] [-Path <String>] [-RestrictToSingleComputer] [-SamAccountName
  <String>] [-Server <String>] [-ServicePrincipalNames <String[]>] [-TrustedForDelegation
  <Boolean>] [<CommonParameters>]
- New-ADServiceAccount [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-AuthenticationPolicy <ADAuthenticationPolicy>] [-AuthenticationPolicySilo
  <ADAuthenticationPolicySilo>] [-AuthType <ADAuthType>] [-Certificates <String[]>]
  [-Credential <PSCredential>] [-Description <String>] [-DisplayName <String>] [-Enabled
  <Boolean>] [-HomePage <String>] [-Instance <ADServiceAccount>] [-KerberosEncryptionType
  <ADKerberosEncryptionType>] [-Name] <String> [-OtherAttributes <Hashtable>] [-PassThru]
  [-Path <String>] [-RestrictToOutboundAuthenticationOnly] [-SamAccountName <String>]
  [-Server <String>] [-ServicePrincipalNames <String[]>] [-TrustedForDelegation <Boolean>]
  [<CommonParameters>]
options:
  -AccountExpirationDate DateTime: ~
  -AccountNotDelegated Boolean: ~
  -AccountPassword SecureString: ~
  -AuthenticationPolicy ADAuthenticationPolicy: ~
  -AuthenticationPolicySilo ADAuthenticationPolicySilo: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Certificates String[]: ~
  -CompoundIdentitySupported Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -DNSHostName String:
    required: true
  -Enabled Boolean: ~
  -HomePage String: ~
  -Instance ADServiceAccount: ~
  -KerberosEncryptionType ADKerberosEncryptionType:
    values:
    - None
    - DES
    - RC4
    - AES128
    - AES256
  -ManagedPasswordIntervalInDays Int32: ~
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -Path String: ~
  -PrincipalsAllowedToDelegateToAccount ADPrincipal[]: ~
  -PrincipalsAllowedToRetrieveManagedPassword ADPrincipal[]: ~
  -RestrictToOutboundAuthenticationOnly Switch:
    required: true
    values:
    - 'true'
  -RestrictToSingleComputer Switch:
    required: true
    values:
    - 'true'
  -SamAccountName String: ~
  -Server String: ~
  -ServicePrincipalNames String[]: ~
  -TrustedForDelegation Boolean: ~
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
