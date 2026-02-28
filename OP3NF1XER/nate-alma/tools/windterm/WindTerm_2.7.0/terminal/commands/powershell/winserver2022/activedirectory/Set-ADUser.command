description: Modifies an Active Directory user
synopses:
- Set-ADUser [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-Add <Hashtable>] [-AllowReversiblePasswordEncryption <Boolean>] [-AuthenticationPolicy
  <ADAuthenticationPolicy>] [-AuthenticationPolicySilo <ADAuthenticationPolicySilo>]
  [-AuthType <ADAuthType>] [-CannotChangePassword <Boolean>] [-Certificates <Hashtable>]
  [-ChangePasswordAtLogon <Boolean>] [-City <String>] [-Clear <String[]>] [-Company
  <String>] [-CompoundIdentitySupported <Boolean>] [-Country <String>] [-Credential
  <PSCredential>] [-Department <String>] [-Description <String>] [-DisplayName <String>]
  [-Division <String>] [-EmailAddress <String>] [-EmployeeID <String>] [-EmployeeNumber
  <String>] [-Enabled <Boolean>] [-Fax <String>] [-GivenName <String>] [-HomeDirectory
  <String>] [-HomeDrive <String>] [-HomePage <String>] [-HomePhone <String>] [-Identity]
  <ADUser> [-Initials <String>] [-KerberosEncryptionType <ADKerberosEncryptionType>]
  [-LogonWorkstations <String>] [-Manager <ADUser>] [-MobilePhone <String>] [-Office
  <String>] [-OfficePhone <String>] [-Organization <String>] [-OtherName <String>]
  [-Partition <String>] [-PassThru] [-PasswordNeverExpires <Boolean>] [-PasswordNotRequired
  <Boolean>] [-POBox <String>] [-PostalCode <String>] [-PrincipalsAllowedToDelegateToAccount
  <ADPrincipal[]>] [-ProfilePath <String>] [-Remove <Hashtable>] [-Replace <Hashtable>]
  [-SamAccountName <String>] [-ScriptPath <String>] [-Server <String>] [-ServicePrincipalNames
  <Hashtable>] [-SmartcardLogonRequired <Boolean>] [-State <String>] [-StreetAddress
  <String>] [-Surname <String>] [-Title <String>] [-TrustedForDelegation <Boolean>]
  [-UserPrincipalName <String>] [<CommonParameters>]
- Set-ADUser [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -Instance <ADUser> [-PassThru] [-SamAccountName <String>] [-Server <String>] [<CommonParameters>]
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
  -City String: ~
  -Clear String[]: ~
  -Company String: ~
  -CompoundIdentitySupported Boolean: ~
  -Confirm,-cf Switch: ~
  -Country String: ~
  -Credential PSCredential: ~
  -Department String: ~
  -Description String: ~
  -DisplayName String: ~
  -Division String: ~
  -EmailAddress String: ~
  -EmployeeID String: ~
  -EmployeeNumber String: ~
  -Enabled Boolean: ~
  -Fax String: ~
  -GivenName String: ~
  -HomeDirectory String: ~
  -HomeDrive String: ~
  -HomePage String: ~
  -HomePhone String: ~
  -Identity ADUser:
    required: true
  -Initials String: ~
  -Instance ADUser:
    required: true
  -KerberosEncryptionType ADKerberosEncryptionType:
    values:
    - None
    - DES
    - RC4
    - AES128
    - AES256
  -LogonWorkstations String: ~
  -Manager ADUser: ~
  -MobilePhone String: ~
  -Office String: ~
  -OfficePhone String: ~
  -Organization String: ~
  -OtherName String: ~
  -Partition String: ~
  -PassThru Switch: ~
  -PasswordNeverExpires Boolean: ~
  -PasswordNotRequired Boolean: ~
  -POBox String: ~
  -PostalCode String: ~
  -PrincipalsAllowedToDelegateToAccount ADPrincipal[]: ~
  -ProfilePath String: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -SamAccountName String: ~
  -ScriptPath String: ~
  -Server String: ~
  -ServicePrincipalNames Hashtable: ~
  -SmartcardLogonRequired Boolean: ~
  -State String: ~
  -StreetAddress String: ~
  -Surname String: ~
  -Title String: ~
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
