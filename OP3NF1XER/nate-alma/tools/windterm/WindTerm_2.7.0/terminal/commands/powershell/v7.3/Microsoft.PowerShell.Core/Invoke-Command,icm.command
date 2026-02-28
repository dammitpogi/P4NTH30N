description: Runs commands on local and remote computers
synopses:
- Invoke-Command [-StrictMode <Version>] [-ScriptBlock] <ScriptBlock> [-NoNewScope]
  [-InputObject <PSObject>] [-ArgumentList <Object[]>] [<CommonParameters>]
- Invoke-Command [[-Session] <PSSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-HideComputerName]
  [-JobName <String>] [-FilePath] <String> [-RemoteDebug] [-InputObject <PSObject>]
  [-ArgumentList <Object[]>] [<CommonParameters>]
- Invoke-Command [[-Session] <PSSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-HideComputerName]
  [-JobName <String>] [-ScriptBlock] <ScriptBlock> [-RemoteDebug] [-InputObject <PSObject>]
  [-ArgumentList <Object[]>] [<CommonParameters>]
- Invoke-Command [[-ComputerName] <String[]>] [-Credential <PSCredential>] [-Port
  <Int32>] [-UseSSL] [-ConfigurationName <String>] [-ApplicationName <String>] [-ThrottleLimit
  <Int32>] [-AsJob] [-InDisconnectedSession] [-SessionName <String[]>] [-HideComputerName]
  [-JobName <String>] [-FilePath] <String> [-SessionOption <PSSessionOption>] [-Authentication
  <AuthenticationMechanism>] [-EnableNetworkAccess] [-RemoteDebug] [-InputObject <PSObject>]
  [-ArgumentList <Object[]>] [<CommonParameters>]
- Invoke-Command [[-ComputerName] <String[]>] [-Credential <PSCredential>] [-Port
  <Int32>] [-UseSSL] [-ConfigurationName <String>] [-ApplicationName <String>] [-ThrottleLimit
  <Int32>] [-AsJob] [-InDisconnectedSession] [-SessionName <String[]>] [-HideComputerName]
  [-JobName <String>] [-ScriptBlock] <ScriptBlock> [-SessionOption <PSSessionOption>]
  [-Authentication <AuthenticationMechanism>] [-EnableNetworkAccess] [-RemoteDebug]
  [-InputObject <PSObject>] [-ArgumentList <Object[]>] [-CertificateThumbprint <String>]
  [<CommonParameters>]
- Invoke-Command [-Credential <PSCredential>] [-ConfigurationName <String>] [-ThrottleLimit
  <Int32>] [[-ConnectionUri] <Uri[]>] [-AsJob] [-InDisconnectedSession] [-HideComputerName]
  [-JobName <String>] [-ScriptBlock] <ScriptBlock> [-AllowRedirection] [-SessionOption
  <PSSessionOption>] [-Authentication <AuthenticationMechanism>] [-EnableNetworkAccess]
  [-RemoteDebug] [-InputObject <PSObject>] [-ArgumentList <Object[]>] [-CertificateThumbprint
  <String>] [<CommonParameters>]
- Invoke-Command [-Credential <PSCredential>] [-ConfigurationName <String>] [-ThrottleLimit
  <Int32>] [[-ConnectionUri] <Uri[]>] [-AsJob] [-InDisconnectedSession] [-HideComputerName]
  [-JobName <String>] [-FilePath] <String> [-AllowRedirection] [-SessionOption <PSSessionOption>]
  [-Authentication <AuthenticationMechanism>] [-EnableNetworkAccess] [-RemoteDebug]
  [-InputObject <PSObject>] [-ArgumentList <Object[]>] [<CommonParameters>]
- Invoke-Command -Credential <PSCredential> [-ConfigurationName <String>] [-ThrottleLimit
  <Int32>] [-AsJob] [-HideComputerName] [-ScriptBlock] <ScriptBlock> [-RemoteDebug]
  [-InputObject <PSObject>] [-ArgumentList <Object[]>] [-VMId] <Guid[]> [<CommonParameters>]
- Invoke-Command -Credential <PSCredential> [-ConfigurationName <String>] [-ThrottleLimit
  <Int32>] [-AsJob] [-HideComputerName] [-ScriptBlock] <ScriptBlock> [-RemoteDebug]
  [-InputObject <PSObject>] [-ArgumentList <Object[]>] -VMName <String[]> [<CommonParameters>]
- Invoke-Command -Credential <PSCredential> [-ConfigurationName <String>] [-ThrottleLimit
  <Int32>] [-AsJob] [-HideComputerName] [-FilePath] <String> [-RemoteDebug] [-InputObject
  <PSObject>] [-ArgumentList <Object[]>] [-VMId] <Guid[]> [<CommonParameters>]
- Invoke-Command -Credential <PSCredential> [-ConfigurationName <String>] [-ThrottleLimit
  <Int32>] [-AsJob] [-HideComputerName] [-FilePath] <String> [-RemoteDebug] [-InputObject
  <PSObject>] [-ArgumentList <Object[]>] -VMName <String[]> [<CommonParameters>]
- Invoke-Command [-Port <Int32>] [-AsJob] [-HideComputerName] [-JobName <String>]
  [-ScriptBlock] <ScriptBlock> -HostName <String[]> [-UserName <String>] [-KeyFilePath
  <String>] [-Subsystem <String>] [-ConnectingTimeout <Int32>] [-SSHTransport] [-Options
  <Hashtable>] [-RemoteDebug] [-InputObject <PSObject>] [-ArgumentList <Object[]>]
  [<CommonParameters>]
- Invoke-Command [-ConfigurationName <String>] [-ThrottleLimit <Int32>] [-AsJob] [-HideComputerName]
  [-JobName <String>] [-ScriptBlock] <ScriptBlock> [-RunAsAdministrator] [-RemoteDebug]
  [-InputObject <PSObject>] [-ArgumentList <Object[]>] -ContainerId <String[]> [<CommonParameters>]
- Invoke-Command [-ConfigurationName <String>] [-ThrottleLimit <Int32>] [-AsJob] [-HideComputerName]
  [-JobName <String>] [-FilePath] <String> [-RunAsAdministrator] [-RemoteDebug] [-InputObject
  <PSObject>] [-ArgumentList <Object[]>] -ContainerId <String[]> [<CommonParameters>]
- Invoke-Command [-AsJob] [-HideComputerName] [-JobName <String>] [-ScriptBlock] <ScriptBlock>
  -SSHConnection <Hashtable[]> [-RemoteDebug] [-InputObject <PSObject>] [-ArgumentList
  <Object[]>] [<CommonParameters>]
- Invoke-Command [-AsJob] [-HideComputerName] [-FilePath] <String> -HostName <String[]>
  [-UserName <String>] [-KeyFilePath <String>] [-Subsystem <String>] [-ConnectingTimeout
  <Int32>] [-SSHTransport] [-Options <Hashtable>] [-RemoteDebug] [-InputObject <PSObject>]
  [-ArgumentList <Object[]>] [<CommonParameters>]
- Invoke-Command [-AsJob] [-HideComputerName] [-FilePath] <String> -SSHConnection
  <Hashtable[]> [-RemoteDebug] [-InputObject <PSObject>] [-ArgumentList <Object[]>]
  [<CommonParameters>]
options:
  -AllowRedirection Switch: ~
  -ApplicationName System.String: ~
  -ArgumentList,-Args System.Object[]: ~
  -AsJob Switch: ~
  -Authentication System.Management.Automation.Runspaces.AuthenticationMechanism:
    values:
    - Basic
    - Default
    - Credssp
    - Digest
    - Kerberos
    - Negotiate
    - NegotiateWithImplicitCredential
  -CertificateThumbprint System.String: ~
  -ComputerName,-Cn System.String[]: ~
  -ConfigurationName System.String: ~
  -ConnectingTimeout System.Int32: ~
  -ConnectionUri,-URI,-CU System.Uri[]: ~
  -ContainerId System.String[]:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -EnableNetworkAccess Switch: ~
  -FilePath,-PSPath System.String:
    required: true
  -HideComputerName,-HCN Switch: ~
  -HostName System.String[]:
    required: true
  -InDisconnectedSession,-Disconnected Switch: ~
  -InputObject System.Management.Automation.PSObject: ~
  -JobName System.String: ~
  -KeyFilePath,-IdentityFilePath System.String: ~
  -NoNewScope Switch: ~
  -Options System.Collections.Hashtable: ~
  -Port System.Int32: ~
  -RemoteDebug Switch: ~
  -RunAsAdministrator Switch: ~
  -ScriptBlock,-Command System.Management.Automation.ScriptBlock:
    required: true
  -Session System.Management.Automation.Runspaces.PSSession[]: ~
  -SessionName System.String[]: ~
  -SessionOption System.Management.Automation.Remoting.PSSessionOption: ~
  -SSHConnection System.Collections.Hashtable[]:
    required: true
  -SSHTransport Switch:
    values:
    - 'true'
  -StrictMode System.Version: ~
  -Subsystem System.String: ~
  -ThrottleLimit System.Int32: ~
  -UserName System.String: ~
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
