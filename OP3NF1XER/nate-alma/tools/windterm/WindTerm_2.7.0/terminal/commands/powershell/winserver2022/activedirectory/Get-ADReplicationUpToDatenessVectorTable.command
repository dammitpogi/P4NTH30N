description: Displays the highest Update Sequence Number (USN) for the specified domain
  controller
synopses:
- Get-ADReplicationUpToDatenessVectorTable [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-EnumerationServer <String>] [-Filter <String>] [[-Partition] <String[]>] [-Target]
  <Object[]> [<CommonParameters>]
- Get-ADReplicationUpToDatenessVectorTable [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-EnumerationServer <String>] [-Filter <String>] [[-Partition] <String[]>] [-Scope]
  <ADScopeType> [[-Target] <Object[]>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -EnumerationServer String: ~
  -Filter String: ~
  -Partition,-NC,-NamingContext String[]: ~
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
