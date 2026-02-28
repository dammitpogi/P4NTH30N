description: Modifies an Active Directory organizational unit
synopses:
- Set-ADOrganizationalUnit [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-City <String>] [-Clear <String[]>] [-Country <String>] [-Credential <PSCredential>]
  [-Description <String>] [-DisplayName <String>] [-Identity] <ADOrganizationalUnit>
  [-ManagedBy <ADPrincipal>] [-Partition <String>] [-PassThru] [-PostalCode <String>]
  [-ProtectedFromAccidentalDeletion <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>]
  [-Server <String>] [-State <String>] [-StreetAddress <String>] [<CommonParameters>]
- Set-ADOrganizationalUnit [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADOrganizationalUnit> [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -City String: ~
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Country String: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -Identity ADOrganizationalUnit:
    required: true
  -Instance ADOrganizationalUnit:
    required: true
  -ManagedBy ADPrincipal: ~
  -Partition String: ~
  -PassThru Switch: ~
  -PostalCode String: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -Server String: ~
  -State String: ~
  -StreetAddress String: ~
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
