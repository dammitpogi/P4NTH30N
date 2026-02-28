description: Modifies an Active Directory managed service account or group managed
  service account object
synopses:
- Set-ADServiceAccount [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-Add <Hashtable>] [-AuthenticationPolicy <ADAuthenticationPolicy>] [-AuthenticationPolicySilo
  <ADAuthenticationPolicySilo>] [-AuthType <ADAuthType>] [-Certificates <String[]>]
  [-Clear <String[]>] [-CompoundIdentitySupported <Boolean>] [-Credential <PSCredential>]
  [-Description <String>] [-DisplayName <String>] [-DNSHostName <String>] [-Enabled
  <Boolean>] [-HomePage <String>] [-Identity] <ADServiceAccount> [-KerberosEncryptionType
  <ADKerberosEncryptionType>] [-Partition <String>] [-PassThru] [-PrincipalsAllowedToDelegateToAccount
  <ADPrincipal[]>] [-PrincipalsAllowedToRetrieveManagedPassword <ADPrincipal[]>] [-Remove
  <Hashtable>] [-Replace <Hashtable>] [-SamAccountName <String>] [-Server <String>]
  [-ServicePrincipalNames <Hashtable>] [-TrustedForDelegation <Boolean>] [<CommonParameters>]
- Set-ADServiceAccount [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADServiceAccount> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -AccountExpirationDate DateTime: ~
  -AccountNotDelegated Boolean: ~
  -Add Hashtable: ~
  -AuthenticationPolicy ADAuthenticationPolicy: ~
  -AuthenticationPolicySilo ADAuthenticationPolicySilo: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Certificates String[]: ~
  -Clear String[]: ~
  -CompoundIdentitySupported Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -DNSHostName String: ~
  -Enabled Boolean: ~
  -HomePage String: ~
  -Identity ADServiceAccount:
    required: true
  -Instance ADServiceAccount:
    required: true
  -KerberosEncryptionType ADKerberosEncryptionType:
    values:
    - None
    - DES
    - RC4
    - AES128
    - AES256
  -Partition String: ~
  -PassThru Switch: ~
  -PrincipalsAllowedToDelegateToAccount ADPrincipal[]: ~
  -PrincipalsAllowedToRetrieveManagedPassword ADPrincipal[]: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -SamAccountName String: ~
  -Server String: ~
  -ServicePrincipalNames Hashtable: ~
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
