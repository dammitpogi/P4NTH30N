description: Returns a collection of data describing an Active Directory replication
  failure
synopses:
- Get-ADReplicationFailure [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-EnumeratingServer
  <String>] [-Filter <String>] [-Target] <Object[]> [<CommonParameters>]
- Get-ADReplicationFailure [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-EnumeratingServer
  <String>] [-Filter <String>] [-Scope] <ADScopeType> [[-Target] <Object[]>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -EnumeratingServer String: ~
  -Filter String: ~
  -Scope,-ReplicationSite ADScopeType:
    required: true
    values:
    - Server
    - Domain
    - Forest
    - Site
  -Target,-Name,-HostName,-Site,-Domain,-Forest Object[]:
    required: true
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
