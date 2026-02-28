description: Gets one or more Active Directory fine-grained password policies
synopses:
- Get-ADFineGrainedPasswordPolicy [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -Filter <String> [-Properties <String[]>] [-ResultPageSize <Int32>] [-ResultSetSize
  <Int32>] [-SearchBase <String>] [-SearchScope <ADSearchScope>] [-Server <String>]
  [<CommonParameters>]
- Get-ADFineGrainedPasswordPolicy [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-Identity] <ADFineGrainedPasswordPolicy> [-Properties <String[]>] [-Server <String>]
  [<CommonParameters>]
- Get-ADFineGrainedPasswordPolicy [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -LDAPFilter <String> [-Properties <String[]>] [-ResultPageSize <Int32>] [-ResultSetSize
  <Int32>] [-SearchBase <String>] [-SearchScope <ADSearchScope>] [-Server <String>]
  [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Filter String:
    required: true
  -Identity ADFineGrainedPasswordPolicy:
    required: true
  -LDAPFilter String:
    required: true
  -Properties,-Property String[]: ~
  -ResultPageSize Int32: ~
  -ResultSetSize Int32: ~
  -SearchBase String: ~
  -SearchScope ADSearchScope:
    values:
    - Base
    - OneLevel
    - Subtree
  -Server String: ~
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
