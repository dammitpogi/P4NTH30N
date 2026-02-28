description: Modifies configuration settings for an identity mapping store
synopses:
- Set-NfsMappingStore [-InputObject <CimInstance[]>] [-EnableUNMLookup <Boolean>]
  [-UNMServer <String>] [-EnableADLookup <Boolean>] [-ADDomainName <String>] [-EnableLdapLookup
  <Boolean>] [-LdapServer <String>] [-LdapNamingContext <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADDomainName,-domain String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EnableADLookup,-ad,-AdLookUp Boolean: ~
  -EnableLdapLookup,-ldap,-LdapLookup Boolean: ~
  -EnableUNMLookup,-unm,-UNMLookUp Boolean: ~
  -InputObject CimInstance[]: ~
  -LdapNamingContext,-LdapContext String: ~
  -LdapServer String: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -UNMServer String: ~
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
