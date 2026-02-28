description: Gets the members of the allowed list or denied list of a read-only domain
  controller's password replication policy
synopses:
- Get-ADDomainControllerPasswordReplicationPolicy [-Allowed] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] [-Identity] <ADDomainController> [-Server <String>]
  [<CommonParameters>]
- Get-ADDomainControllerPasswordReplicationPolicy [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Denied] [-Identity] <ADDomainController> [-Server <String>] [<CommonParameters>]
options:
  -Allowed Switch: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Denied Switch:
    required: true
  -Identity ADDomainController:
    required: true
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
