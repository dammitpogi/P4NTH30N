description: Gets the Active Directory accounts that are authenticated by a read-only
  domain controller or that are in the revealed list of the domain controller
synopses:
- Get-ADDomainControllerPasswordReplicationPolicyUsage [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Identity] <ADDomainController> [-RevealedAccounts] [-Server <String>]
  [<CommonParameters>]
- Get-ADDomainControllerPasswordReplicationPolicyUsage [-AuthenticatedAccounts] [-AuthType
  <ADAuthType>] [-Credential <PSCredential>] [-Identity] <ADDomainController> [-Server
  <String>] [<CommonParameters>]
options:
  -AuthenticatedAccounts Switch:
    required: true
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Identity ADDomainController:
    required: true
  -RevealedAccounts Switch: ~
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
