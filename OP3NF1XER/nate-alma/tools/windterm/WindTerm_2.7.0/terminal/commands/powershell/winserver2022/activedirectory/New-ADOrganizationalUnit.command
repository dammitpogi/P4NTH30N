description: Creates an Active Directory organizational unit
synopses:
- New-ADOrganizationalUnit [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-City <String>]
  [-Country <String>] [-Credential <PSCredential>] [-Description <String>] [-DisplayName
  <String>] [-Instance <ADOrganizationalUnit>] [-ManagedBy <ADPrincipal>] [-Name]
  <String> [-OtherAttributes <Hashtable>] [-PassThru] [-Path <String>] [-PostalCode
  <String>] [-ProtectedFromAccidentalDeletion <Boolean>] [-Server <String>] [-State
  <String>] [-StreetAddress <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -City String: ~
  -Confirm,-cf Switch: ~
  -Country String: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -Instance ADOrganizationalUnit: ~
  -ManagedBy ADPrincipal: ~
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -Path String: ~
  -PostalCode String: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
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
