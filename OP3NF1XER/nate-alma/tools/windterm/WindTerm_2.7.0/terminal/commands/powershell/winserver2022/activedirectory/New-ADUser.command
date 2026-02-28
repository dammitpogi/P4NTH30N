description: Creates an Active Directory user
synopses:
- New-ADUser [-WhatIf] [-Confirm] [-AccountExpirationDate <DateTime>] [-AccountNotDelegated
  <Boolean>] [-AccountPassword <SecureString>] [-AllowReversiblePasswordEncryption
  <Boolean>] [-AuthenticationPolicy <ADAuthenticationPolicy>] [-AuthenticationPolicySilo
  <ADAuthenticationPolicySilo>] [-AuthType <ADAuthType>] [-CannotChangePassword <Boolean>]
  [-Certificates <X509Certificate[]>] [-ChangePasswordAtLogon <Boolean>] [-City <String>]
  [-Company <String>] [-CompoundIdentitySupported <Boolean>] [-Country <String>] [-Credential
  <PSCredential>] [-Department <String>] [-Description <String>] [-DisplayName <String>]
  [-Division <String>] [-EmailAddress <String>] [-EmployeeID <String>] [-EmployeeNumber
  <String>] [-Enabled <Boolean>] [-Fax <String>] [-GivenName <String>] [-HomeDirectory
  <String>] [-HomeDrive <String>] [-HomePage <String>] [-HomePhone <String>] [-Initials
  <String>] [-Instance <ADUser>] [-KerberosEncryptionType <ADKerberosEncryptionType>]
  [-LogonWorkstations <String>] [-Manager <ADUser>] [-MobilePhone <String>] [-Name]
  <String> [-Office <String>] [-OfficePhone <String>] [-Organization <String>] [-OtherAttributes
  <Hashtable>] [-OtherName <String>] [-PassThru] [-PasswordNeverExpires <Boolean>]
  [-PasswordNotRequired <Boolean>] [-Path <String>] [-POBox <String>] [-PostalCode
  <String>] [-PrincipalsAllowedToDelegateToAccount <ADPrincipal[]>] [-ProfilePath
  <String>] [-SamAccountName <String>] [-ScriptPath <String>] [-Server <String>] [-ServicePrincipalNames
  <String[]>] [-SmartcardLogonRequired <Boolean>] [-State <String>] [-StreetAddress
  <String>] [-Surname <String>] [-Title <String>] [-TrustedForDelegation <Boolean>]
  [-Type <String>] [-UserPrincipalName <String>] [<CommonParameters>]
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
  -City String: ~
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
  -Initials String: ~
  -Instance ADUser: ~
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
  -Name String:
    required: true
  -Office String: ~
  -OfficePhone String: ~
  -Organization String: ~
  -OtherAttributes Hashtable: ~
  -OtherName String: ~
  -PassThru Switch: ~
  -PasswordNeverExpires Boolean: ~
  -PasswordNotRequired Boolean: ~
  -Path String: ~
  -POBox String: ~
  -PostalCode String: ~
  -PrincipalsAllowedToDelegateToAccount ADPrincipal[]: ~
  -ProfilePath String: ~
  -SamAccountName String: ~
  -ScriptPath String: ~
  -Server String: ~
  -ServicePrincipalNames String[]: ~
  -SmartcardLogonRequired Boolean: ~
  -State String: ~
  -StreetAddress String: ~
  -Surname String: ~
  -Title String: ~
  -TrustedForDelegation Boolean: ~
  -Type String: ~
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
