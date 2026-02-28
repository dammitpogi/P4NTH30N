description: Tests the connection between a primary server and a Replica server
synopses:
- Test-VMReplicationConnection [-ReplicaServerName] <String> [-ReplicaServerPort]
  <Int32> [-AuthenticationType] <ReplicationAuthenticationType> [[-CertificateThumbprint]
  <String>] [-BypassProxyServer <Boolean>] [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [<CommonParameters>]
options:
  -AuthenticationType,-AuthType ReplicationAuthenticationType:
    required: true
    values:
    - Kerberos
    - Certificate
  -BypassProxyServer Boolean: ~
  -CertificateThumbprint,-Thumbprint String: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -ReplicaServerName,-ReplicaServer String:
    required: true
  -ReplicaServerPort,-ReplicaPort Int32:
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
