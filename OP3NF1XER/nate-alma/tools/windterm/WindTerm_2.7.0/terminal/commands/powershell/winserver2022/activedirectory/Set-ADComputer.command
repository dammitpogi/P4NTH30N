description: Modifies an Active Directory computer object
synopses:
- Set-ADComputer [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-Add <Hashtable>] [-AllowReversiblePasswordEncryption <Boolean>] [-AuthenticationPolicy
  <ADAuthenticationPolicy>] [-AuthenticationPolicySilo <ADAuthenticationPolicySilo>]
  [-AuthType <ADAuthType>] [-CannotChangePassword <Boolean>] [-Certificates <Hashtable>]
  [-ChangePasswordAtLogon <Boolean>] [-Clear <String[]>] [-CompoundIdentitySupported
  <Boolean>] [-Credential <PSCredential>] [-Description <String>] [-DisplayName <String>]
  [-DNSHostName <String>] [-Enabled <Boolean>] [-HomePage <String>] [-Identity] <ADComputer>
  [-KerberosEncryptionType <ADKerberosEncryptionType>] [-Location <String>] [-ManagedBy
  <ADPrincipal>] [-OperatingSystem <String>] [-OperatingSystemHotfix <String>] [-OperatingSystemServicePack
  <String>] [-OperatingSystemVersion <String>] [-Partition <String>] [-PassThru] [-PasswordNeverExpires
  <Boolean>] [-PasswordNotRequired <Boolean>] [-PrincipalsAllowedToDelegateToAccount
  <ADPrincipal[]>] [-Remove <Hashtable>] [-Replace <Hashtable>] [-SAMAccountName <String>]
  [-Server <String>] [-ServicePrincipalNames <Hashtable>] [-TrustedForDelegation <Boolean>]
  [-UserPrincipalName <String>] [<CommonParameters>]
- Set-ADComputer [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -Instance <ADComputer> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -AccountExpirationDate DateTime: ~
  -AccountNotDelegated Boolean: ~
  -Add Hashtable: ~
  -AllowReversiblePasswordEncryption Boolean: ~
  -AuthenticationPolicy ADAuthenticationPolicy: ~
  -AuthenticationPolicySilo ADAuthenticationPolicySilo: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -CannotChangePassword Boolean: ~
  -Certificates Hashtable: ~
  -ChangePasswordAtLogon Boolean: ~
  -Clear String[]: ~
  -CompoundIdentitySupported Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -DNSHostName String: ~
  -Enabled Boolean: ~
  -HomePage String: ~
  -Identity ADComputer:
    required: true
  -Instance ADComputer:
    required: true
  -KerberosEncryptionType ADKerberosEncryptionType:
    values:
    - None
    - DES
    - RC4
    - AES128
    - AES256
  -Location String: ~
  -ManagedBy ADPrincipal: ~
  -OperatingSystem String: ~
  -OperatingSystemHotfix String: ~
  -OperatingSystemServicePack String: ~
  -OperatingSystemVersion String: ~
  -Partition String: ~
  -PassThru Switch: ~
  -PasswordNeverExpires Boolean: ~
  -PasswordNotRequired Boolean: ~
  -PrincipalsAllowedToDelegateToAccount ADPrincipal[]: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -SAMAccountName String: ~
  -Server String: ~
  -ServicePrincipalNames Hashtable: ~
  -TrustedForDelegation Boolean: ~
  -UserPrincipalName String: ~
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
