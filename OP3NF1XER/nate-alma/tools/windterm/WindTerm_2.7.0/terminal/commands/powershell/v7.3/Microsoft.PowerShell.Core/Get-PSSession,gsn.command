description: Gets the PowerShell sessions on local and remote computers
synopses:
- Get-PSSession [-Name <String[]>] [<CommonParameters>]
- Get-PSSession [-ComputerName] <String[]> [-ApplicationName <String>] [-ConfigurationName
  <String>] [-Name <String[]>] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-Port <Int32>] [-UseSSL] [-ThrottleLimit <Int32>]
  [-State <SessionFilterState>] [-SessionOption <PSSessionOption>] [<CommonParameters>]
- Get-PSSession [-ComputerName] <String[]> [-ApplicationName <String>] [-ConfigurationName
  <String>] -InstanceId <Guid[]> [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-Port <Int32>] [-UseSSL] [-ThrottleLimit <Int32>]
  [-State <SessionFilterState>] [-SessionOption <PSSessionOption>] [<CommonParameters>]
- Get-PSSession [-ConnectionUri] <Uri[]> [-ConfigurationName <String>] [-AllowRedirection]
  [-Name <String[]>] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-ThrottleLimit <Int32>] [-State <SessionFilterState>]
  [-SessionOption <PSSessionOption>] [<CommonParameters>]
- Get-PSSession [-ConnectionUri] <Uri[]> [-ConfigurationName <String>] [-AllowRedirection]
  -InstanceId <Guid[]> [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-ThrottleLimit <Int32>] [-State <SessionFilterState>]
  [-SessionOption <PSSessionOption>] [<CommonParameters>]
- Get-PSSession [-ConfigurationName <String>] -InstanceId <Guid[]> [-State <SessionFilterState>]
  -VMName <String[]> [<CommonParameters>]
- Get-PSSession [-ConfigurationName <String>] [-Name <String[]>] [-State <SessionFilterState>]
  -ContainerId <String[]> [<CommonParameters>]
- Get-PSSession [-ConfigurationName <String>] -InstanceId <Guid[]> [-State <SessionFilterState>]
  -ContainerId <String[]> [<CommonParameters>]
- Get-PSSession [-ConfigurationName <String>] [-Name <String[]>] [-State <SessionFilterState>]
  -VMId <Guid[]> [<CommonParameters>]
- Get-PSSession [-ConfigurationName <String>] -InstanceId <Guid[]> [-State <SessionFilterState>]
  -VMId <Guid[]> [<CommonParameters>]
- Get-PSSession [-ConfigurationName <String>] [-Name <String[]>] [-State <SessionFilterState>]
  -VMName <String[]> [<CommonParameters>]
- Get-PSSession [-InstanceId <Guid[]>] [<CommonParameters>]
- Get-PSSession [-Id] <Int32[]> [<CommonParameters>]
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
  -ComputerName,-Cn System.String[]:
    required: true
  -ConfigurationName System.String: ~
  -ConnectionUri,-URI,-CU System.Uri[]:
    required: true
  -ContainerId System.String[]:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -Id System.Int32[]:
    required: true
  -InstanceId System.Guid[]: ~
  -Name System.String[]: ~
  -Port System.Int32: ~
  -SessionOption System.Management.Automation.Remoting.PSSessionOption: ~
  -State Microsoft.PowerShell.Commands.SessionFilterState:
    values:
    - All
    - Opened
    - Disconnected
    - Closed
    - Broken
  -ThrottleLimit System.Int32: ~
  -UseSSL Switch: ~
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
