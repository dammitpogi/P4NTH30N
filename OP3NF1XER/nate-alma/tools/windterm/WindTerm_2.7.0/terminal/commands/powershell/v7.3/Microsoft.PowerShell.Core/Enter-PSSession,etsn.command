description: Starts an interactive session with a remote computer
synopses:
- Enter-PSSession [-ComputerName] <String> [-EnableNetworkAccess] [[-Credential] <PSCredential>]
  [-ConfigurationName <String>] [-Port <Int32>] [-UseSSL] [-ApplicationName <String>]
  [-SessionOption <PSSessionOption>] [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint
  <String>] [<CommonParameters>]
- Enter-PSSession [-HostName] <String> [-Options <Hashtable>] [-Port <Int32>] [-UserName
  <String>] [-KeyFilePath <String>] [-Subsystem <String>] [-ConnectingTimeout <Int32>]
  [-SSHTransport] [<CommonParameters>]
- Enter-PSSession [[-Session] <PSSession>] [<CommonParameters>]
- Enter-PSSession [[-ConnectionUri] <Uri>] [-EnableNetworkAccess] [[-Credential] <PSCredential>]
  [-ConfigurationName <String>] [-AllowRedirection] [-SessionOption <PSSessionOption>]
  [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint <String>] [<CommonParameters>]
- Enter-PSSession [-InstanceId <Guid>] [<CommonParameters>]
- Enter-PSSession [[-Id] <Int32>] [<CommonParameters>]
- Enter-PSSession [-Name <String>] [<CommonParameters>]
- Enter-PSSession [-VMId] <Guid> [-Credential] <PSCredential> [-ConfigurationName
  <String>] [<CommonParameters>]
- Enter-PSSession [-VMName] <String> [-Credential] <PSCredential> [-ConfigurationName
  <String>] [<CommonParameters>]
- Enter-PSSession [-ContainerId] <String> [-ConfigurationName <String>] [-RunAsAdministrator]
  [<CommonParameters>]
options:
  -AllowRedirection Switch: ~
  -ApplicationName System.String: ~
  -Authentication System.Management.Automation.Runspaces.AuthenticationMechanism:
    values:
    - Default
    - Basic
    - Negotiate
    - NegotiateWithImplicitCredential
    - Credssp
    - Digest
    - Kerberos
  -CertificateThumbprint System.String: ~
  -ComputerName,-Cn System.String:
    required: true
  -ConfigurationName System.String: ~
  -ConnectingTimeout System.Int32: ~
  -ConnectionUri,-URI,-CU System.Uri: ~
  -ContainerId System.String:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -EnableNetworkAccess Switch: ~
  -HostName System.String:
    required: true
  -Id System.Int32: ~
  -InstanceId System.Guid: ~
  -KeyFilePath,-IdentityFilePath System.String: ~
  -Name System.String: ~
  -Options System.Collections.Hashtable: ~
  -Port System.Int32: ~
  -RunAsAdministrator Switch: ~
  -Session System.Management.Automation.Runspaces.PSSession: ~
  -SessionOption System.Management.Automation.Remoting.PSSessionOption: ~
  -SSHTransport Switch:
    values:
    - 'true'
  -Subsystem System.String: ~
  -UserName System.String: ~
  -UseSSL Switch: ~
  -VMId,-VMGuid System.Guid:
    required: true
  -VMName System.String:
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
