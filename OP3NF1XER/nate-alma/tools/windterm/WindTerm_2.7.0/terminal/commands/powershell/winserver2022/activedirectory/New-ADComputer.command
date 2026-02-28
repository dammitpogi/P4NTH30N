description: Creates a new Active Directory computer object
synopses:
- New-ADComputer [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-AccountPassword <SecureString>] [-AllowReversiblePasswordEncryption
  <Boolean>] [-AuthenticationPolicy <ADAuthenticationPolicy>] [-AuthenticationPolicySilo
  <ADAuthenticationPolicySilo>] [-AuthType <ADAuthType>] [-CannotChangePassword <Boolean>]
  [-Certificates <X509Certificate[]>] [-ChangePasswordAtLogon <Boolean>] [-CompoundIdentitySupported
  <Boolean>] [-Credential <PSCredential>] [-Description <String>] [-DisplayName <String>]
  [-DNSHostName <String>] [-Enabled <Boolean>] [-HomePage <String>] [-Instance <ADComputer>]
  [-KerberosEncryptionType <ADKerberosEncryptionType>] [-Location <String>] [-ManagedBy
  <ADPrincipal>] [-Name] <String> [-OperatingSystem <String>] [-OperatingSystemHotfix
  <String>] [-OperatingSystemServicePack <String>] [-OperatingSystemVersion <String>]
  [-OtherAttributes <Hashtable>] [-PassThru] [-PasswordNeverExpires <Boolean>] [-PasswordNotRequired
  <Boolean>] [-Path <String>] [-PrincipalsAllowedToDelegateToAccount <ADPrincipal[]>]
  [-SAMAccountName <String>] [-Server <String>] [-ServicePrincipalNames <String[]>]
  [-TrustedForDelegation <Boolean>] [-UserPrincipalName <String>] [<CommonParameters>]
options:
  -AccountExpirationDate DateTime: ~
  -AccountNotDelegated Boolean: ~
  -AccountPassword SecureString: ~
  -AllowReversiblePasswordEncryption Boolean: ~
  -AuthenticationPolicy ADAuthenticationPolicy: ~
  -AuthenticationPolicySilo ADAuthenticationPolicySilo: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -CannotChangePassword Boolean: ~
  -Certificates X509Certificate[]: ~
  -ChangePasswordAtLogon Boolean: ~
  -CompoundIdentitySupported Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -DNSHostName String: ~
  -Enabled Boolean: ~
  -HomePage String: ~
  -Instance ADComputer: ~
  -KerberosEncryptionType ADKerberosEncryptionType:
    values:
    - None
    - DES
    - RC4
    - AES128
    - AES256
  -Location String: ~
  -ManagedBy ADPrincipal: ~
  -Name String:
    required: true
  -OperatingSystem String: ~
  -OperatingSystemHotfix String: ~
  -OperatingSystemServicePack String: ~
  -OperatingSystemVersion String: ~
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -PasswordNeverExpires Boolean: ~
  -PasswordNotRequired Boolean: ~
  -Path String: ~
  -PrincipalsAllowedToDelegateToAccount ADPrincipal[]: ~
  -SAMAccountName String: ~
  -Server String: ~
  -ServicePrincipalNames String[]: ~
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
