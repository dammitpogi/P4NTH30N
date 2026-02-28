description: Gets results of commands in disconnected sessions
synopses:
- Receive-PSSession [-Session] <PSSession> [-OutTarget <OutTarget>] [-JobName <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Receive-PSSession [-Id] <Int32> [-OutTarget <OutTarget>] [-JobName <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Receive-PSSession [-ComputerName] <String> [-ApplicationName <String>] [-ConfigurationName
  <String>] -Name <String> [-OutTarget <OutTarget>] [-JobName <String>] [-Credential
  <PSCredential>] [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint
  <String>] [-Port <Int32>] [-UseSSL] [-SessionOption <PSSessionOption>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Receive-PSSession [-ComputerName] <String> [-ApplicationName <String>] [-ConfigurationName
  <String>] -InstanceId <Guid> [-OutTarget <OutTarget>] [-JobName <String>] [-Credential
  <PSCredential>] [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint
  <String>] [-Port <Int32>] [-UseSSL] [-SessionOption <PSSessionOption>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Receive-PSSession [-ConfigurationName <String>] [-ConnectionUri] <Uri> [-AllowRedirection]
  -Name <String> [-OutTarget <OutTarget>] [-JobName <String>] [-Credential <PSCredential>]
  [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint <String>] [-SessionOption
  <PSSessionOption>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Receive-PSSession [-ConfigurationName <String>] [-ConnectionUri] <Uri> [-AllowRedirection]
  -InstanceId <Guid> [-OutTarget <OutTarget>] [-JobName <String>] [-Credential <PSCredential>]
  [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint <String>] [-SessionOption
  <PSSessionOption>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Receive-PSSession -InstanceId <Guid> [-OutTarget <OutTarget>] [-JobName <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Receive-PSSession -Name <String> [-OutTarget <OutTarget>] [-JobName <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
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
  -ConnectionUri,-URI,-CU System.Uri:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -Id System.Int32:
    required: true
  -InstanceId System.Guid:
    required: true
  -JobName System.String: ~
  -Name System.String:
    required: true
  -OutTarget Microsoft.PowerShell.Commands.OutTarget:
    values:
    - Default
    - Host
    - Job
  -Port System.Int32: ~
  -Session System.Management.Automation.Runspaces.PSSession:
    required: true
  -SessionOption System.Management.Automation.Remoting.PSSessionOption: ~
  -UseSSL Switch: ~
  -Confirm,-cf Switch: ~
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
