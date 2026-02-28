description: Creates a new NFS mapped identity
synopses:
- New-NfsMappedIdentity [-MappingStore <MappingStoreType>] [-Server <String>] [-LdapNamingContext
  <String>] -UserName <String> [-Password <SecureString>] -UserIdentifier <Int32>
  -GroupIdentifier <Int32> [-PrimaryGroup <String>] [-SupplementaryGroups <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-NfsMappedIdentity [-MappingStore <MappingStoreType>] [-Server <String>] [-LdapNamingContext
  <String>] -GroupName <String> [-Password <SecureString>] -GroupIdentifier <Int32>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -GroupIdentifier,-GroupId,-gid Int32:
    required: true
  -GroupName,-group String:
    required: true
  -LdapNamingContext,-dn String: ~
  -MappingStore,-store MappingStoreType:
    values:
    - Ad
    - Ldap
    - Mapfiles
  -Password SecureString: ~
  -PrimaryGroup String: ~
  -Server,-LdapServer,-ADDomainName String: ~
  -SupplementaryGroups,-sg String: ~
  -UserIdentifier,-UserId,-uid Int32:
    required: true
  -UserName,-user String:
    required: true
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
