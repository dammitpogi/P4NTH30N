description: Modifies the default password policy for an Active Directory domain
synopses:
- Set-ADDefaultDomainPasswordPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>]
  [-ComplexityEnabled <Boolean>] [-Credential <PSCredential>] [-Identity] <ADDefaultDomainPasswordPolicy>
  [-LockoutDuration <TimeSpan>] [-LockoutObservationWindow <TimeSpan>] [-LockoutThreshold
  <Int32>] [-MaxPasswordAge <TimeSpan>] [-MinPasswordAge <TimeSpan>] [-MinPasswordLength
  <Int32>] [-PassThru] [-PasswordHistoryCount <Int32>] [-ReversibleEncryptionEnabled
  <Boolean>] [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -ComplexityEnabled Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Identity ADDefaultDomainPasswordPolicy:
    required: true
  -LockoutDuration TimeSpan: ~
  -LockoutObservationWindow TimeSpan: ~
  -LockoutThreshold Int32: ~
  -MaxPasswordAge TimeSpan: ~
  -MinPasswordAge TimeSpan: ~
  -MinPasswordLength Int32: ~
  -PassThru Switch: ~
  -PasswordHistoryCount Int32: ~
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
