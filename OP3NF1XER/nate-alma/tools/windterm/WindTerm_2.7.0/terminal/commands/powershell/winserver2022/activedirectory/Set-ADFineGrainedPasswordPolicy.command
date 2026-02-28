description: Modifies an Active Directory fine-grained password policy
synopses:
- Set-ADFineGrainedPasswordPolicy [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType
  <ADAuthType>] [-Clear <String[]>] [-ComplexityEnabled <Boolean>] [-Credential <PSCredential>]
  [-Description <String>] [-DisplayName <String>] [-Identity] <ADFineGrainedPasswordPolicy>
  [-LockoutDuration <TimeSpan>] [-LockoutObservationWindow <TimeSpan>] [-LockoutThreshold
  <Int32>] [-MaxPasswordAge <TimeSpan>] [-MinPasswordAge <TimeSpan>] [-MinPasswordLength
  <Int32>] [-PassThru] [-PasswordHistoryCount <Int32>] [-Precedence <Int32>] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>] [-ReversibleEncryptionEnabled
  <Boolean>] [-Server <String>] [<CommonParameters>]
- Set-ADFineGrainedPasswordPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADFineGrainedPasswordPolicy> [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -ComplexityEnabled Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -Identity ADFineGrainedPasswordPolicy:
    required: true
  -Instance ADFineGrainedPasswordPolicy:
    required: true
  -LockoutDuration TimeSpan: ~
  -LockoutObservationWindow TimeSpan: ~
  -LockoutThreshold Int32: ~
  -MaxPasswordAge TimeSpan: ~
  -MinPasswordAge TimeSpan: ~
  -MinPasswordLength Int32: ~
  -PassThru Switch: ~
  -PasswordHistoryCount Int32: ~
  -Precedence Int32: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -ReversibleEncryptionEnabled Boolean: ~
  -Server String: ~
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
