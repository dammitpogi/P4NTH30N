description: Modifies user account control (UAC) values for an Active Directory account
synopses:
- Set-ADAccountControl [-WhatIf] [-Confirm] [-AccountNotDelegated <Boolean>] [-AllowReversiblePasswordEncryption
  <Boolean>] [-AuthType <ADAuthType>] [-CannotChangePassword <Boolean>] [-Credential
  <PSCredential>] [-DoesNotRequirePreAuth <Boolean>] [-Enabled <Boolean>] [-HomedirRequired
  <Boolean>] [-Identity] <ADAccount> [-MNSLogonAccount <Boolean>] [-Partition <String>]
  [-PassThru] [-PasswordNeverExpires <Boolean>] [-PasswordNotRequired <Boolean>] [-Server
  <String>] [-TrustedForDelegation <Boolean>] [-TrustedToAuthForDelegation <Boolean>]
  [-UseDESKeyOnly <Boolean>] [<CommonParameters>]
options:
  -AccountNotDelegated Boolean: ~
  -AllowReversiblePasswordEncryption Boolean: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -CannotChangePassword Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DoesNotRequirePreAuth Boolean: ~
  -Enabled Boolean: ~
  -HomedirRequired Boolean: ~
  -Identity ADAccount:
    required: true
  -MNSLogonAccount Boolean: ~
  -Partition String: ~
  -PassThru Switch: ~
  -PasswordNeverExpires Boolean: ~
  -PasswordNotRequired Boolean: ~
  -Server String: ~
  -TrustedForDelegation Boolean: ~
  -TrustedToAuthForDelegation Boolean: ~
  -UseDESKeyOnly Boolean: ~
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
