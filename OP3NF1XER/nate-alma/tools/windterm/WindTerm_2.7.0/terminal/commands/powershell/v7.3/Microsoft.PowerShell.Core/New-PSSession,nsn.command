description: Creates a persistent connection to a local or remote computer
synopses:
- New-PSSession [[-ComputerName] <String[]>] [-Credential <PSCredential>] [-Name <String[]>]
  [-EnableNetworkAccess] [-ConfigurationName <String>] [-Port <Int32>] [-UseSSL] [-ApplicationName
  <String>] [-ThrottleLimit <Int32>] [-SessionOption <PSSessionOption>] [-Authentication
  <AuthenticationMechanism>] [-CertificateThumbprint <String>] [<CommonParameters>]
- New-PSSession [-Credential <PSCredential>] [-Name <String[]>] [-EnableNetworkAccess]
  [-ConfigurationName <String>] [-ThrottleLimit <Int32>] [-ConnectionUri] <Uri[]>
  [-AllowRedirection] [-SessionOption <PSSessionOption>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [<CommonParameters>]
- New-PSSession -Credential <PSCredential> [-Name <String[]>] [-ConfigurationName
  <String>] [-VMId] <Guid[]> [-ThrottleLimit <Int32>] [<CommonParameters>]
- New-PSSession -Credential <PSCredential> [-Name <String[]>] [-ConfigurationName
  <String>] -VMName <String[]> [-ThrottleLimit <Int32>] [<CommonParameters>]
- New-PSSession [[-Session] <PSSession[]>] [-Name <String[]>] [-EnableNetworkAccess]
  [-ThrottleLimit <Int32>] [<CommonParameters>]
- New-PSSession [-Name <String[]>] [-ConfigurationName <String>] -ContainerId <String[]>
  [-RunAsAdministrator] [-ThrottleLimit <Int32>] [<CommonParameters>]
- New-PSSession [-Name <String[]>] [-UseWindowsPowerShell] [<CommonParameters>]
- New-PSSession [-Name <String[]>] [-Port <Int32>] [-HostName] <String[]> [-UserName
  <String>] [-KeyFilePath <String>] [-Subsystem <String>] [-ConnectingTimeout <Int32>]
  [-SSHTransport] [-Options <Hashtable>] [<CommonParameters>]
- New-PSSession [-Name <String[]>] -SSHConnection <Hashtable[]> [<CommonParameters>]
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
  -ComputerName,-Cn System.String[]: ~
  -ConfigurationName System.String: ~
  -ConnectingTimeout System.Int32: ~
  -ConnectionUri,-URI,-CU System.Uri[]:
    required: true
  -ContainerId System.String[]:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -EnableNetworkAccess Switch: ~
  -HostName System.String[]:
    required: true
  -KeyFilePath,-IdentityFilePath System.String: ~
  -Name System.String[]: ~
  -Options System.Collections.Hashtable: ~
  -Port System.Int32: ~
  -RunAsAdministrator Switch: ~
  -Session System.Management.Automation.Runspaces.PSSession[]: ~
  -SessionOption System.Management.Automation.Remoting.PSSessionOption: ~
  -SSHConnection System.Collections.Hashtable[]:
    required: true
  -SSHTransport Switch:
    values:
    - 'true'
  -Subsystem System.String: ~
  -ThrottleLimit System.Int32: ~
  -UserName System.String: ~
  -UseSSL Switch: ~
  -UseWindowsPowerShell Switch:
    required: true
  -VMId,-VMGuid System.Guid[]:
    required: true
  -VMName System.String[]:
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
