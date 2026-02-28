description: Verifies that a mapped identity is correctly configured
synopses:
- Test-NfsMappedIdentity [-MappingStore <MappingStoreType>] [-UserIdentifier <Int32>]
  [-GroupIdentifier <Int32>] [-AccountName <String>] [-AccountType <AccountType>]
  [-SupplementaryGroups <String>] [<CommonParameters>]
- Test-NfsMappedIdentity -MappingStore <MappingStoreType> [-Server <String>] [-LdapNamingContext
  <String>] [-UserIdentifier <Int32>] [-GroupIdentifier <Int32>] [-AccountName <String>]
  [-AccountType <AccountType>] [-SupplementaryGroups <String>] [<CommonParameters>]
- Test-NfsMappedIdentity -MappingStore <MappingStoreType> [-MapFilesPath <String>]
  [-UserIdentifier <Int32>] [-GroupIdentifier <Int32>] [-AccountName <String>] [-AccountType
  <AccountType>] [-SupplementaryGroups <String>] [<CommonParameters>]
options:
  -AccountName,-aname,-an String: ~
  -AccountType,-atype,-at AccountType:
    values:
    - User
    - Group
  -GroupIdentifier,-GroupId,-gid Int32: ~
  -LdapNamingContext,-dn String: ~
  -MapFilesPath String: ~
  -MappingStore,-store MappingStoreType:
    values:
    - Ad
    - Ldap
    - Mapfiles
  -Server,-LdapServer,-ADDomainName String: ~
  -SupplementaryGroups,-sg String: ~
  -UserIdentifier,-UserId,-uid Int32: ~
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
