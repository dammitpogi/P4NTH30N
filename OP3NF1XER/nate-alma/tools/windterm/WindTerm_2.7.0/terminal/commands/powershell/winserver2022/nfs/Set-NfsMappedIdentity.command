description: Modifies a mapped identity
synopses:
- Set-NfsMappedIdentity [-MappingStore <MappingStoreType>] [-Server <String>] [-LdapNamingContext
  <String>] -UserName <String> [-UserIdentifier <Int32>] [-GroupIdentifier <Int32>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NfsMappedIdentity [-MappingStore <MappingStoreType>] [-Server <String>] [-LdapNamingContext
  <String>] -GroupName <String> -GroupIdentifier <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -GroupIdentifier,-GroupId,-gid Int32: ~
  -GroupName,-group String:
    required: true
  -LdapNamingContext,-dn String: ~
  -MappingStore,-store MappingStoreType:
    values:
    - Ad
    - Ldap
    - Mapfiles
  -Server,-LdapServer,-ADDomainName String: ~
  -UserIdentifier,-UserId,-uid Int32: ~
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
