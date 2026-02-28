description: Configures a host as a Replica server
synopses:
- Set-VMReplicationServer [[-ReplicationEnabled] <Boolean>] [[-AllowedAuthenticationType]
  <RecoveryAuthenticationType>] [[-ReplicationAllowedFromAnyServer] <Boolean>] [-CertificateThumbprint
  <String>] [-DefaultStorageLocation <String>] [-KerberosAuthenticationPort <Int32>]
  [-CertificateAuthenticationPort <Int32>] [-MonitoringInterval <TimeSpan>] [-MonitoringStartTime
  <TimeSpan>] [-Force] [-Passthru] [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMReplicationServer [[-ReplicationEnabled] <Boolean>] [[-AllowedAuthenticationType]
  <RecoveryAuthenticationType>] [[-ReplicationAllowedFromAnyServer] <Boolean>] [-CertificateThumbprint
  <String>] [-DefaultStorageLocation <String>] [-KerberosAuthenticationPortMapping
  <Hashtable>] [-CertificateAuthenticationPortMapping <Hashtable>] [-MonitoringInterval
  <TimeSpan>] [-MonitoringStartTime <TimeSpan>] [-Force] [-Passthru] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AllowedAuthenticationType,-AuthType RecoveryAuthenticationType:
    values:
    - Kerberos
    - Certificate
    - CertificateAndKerberos
  -CertificateAuthenticationPort,-CertAuthPort Int32: ~
  -CertificateAuthenticationPortMapping Hashtable: ~
  -CertificateThumbprint,-Thumbprint String: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DefaultStorageLocation,-StorageLoc String: ~
  -Force Switch: ~
  -KerberosAuthenticationPort,-KerbAuthPort Int32: ~
  -KerberosAuthenticationPortMapping Hashtable: ~
  -MonitoringInterval TimeSpan: ~
  -MonitoringStartTime TimeSpan: ~
  -Passthru Switch: ~
  -ReplicationAllowedFromAnyServer,-AllowAnyServer Boolean: ~
  -ReplicationEnabled,-RepEnabled Boolean: ~
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
