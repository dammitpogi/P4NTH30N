description: Reconnects to disconnected sessions
synopses:
- Connect-PSSession -Name <String[]> [-ThrottleLimit <Int32>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Connect-PSSession [-Session] <PSSession[]> [-ThrottleLimit <Int32>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Connect-PSSession -ComputerName <String[]> [-ApplicationName <String>] [-ConfigurationName
  <String>] -InstanceId <Guid[]> [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-Port <Int32>] [-UseSSL] [-SessionOption <PSSessionOption>]
  [-ThrottleLimit <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-PSSession -ComputerName <String[]> [-ApplicationName <String>] [-ConfigurationName
  <String>] [-Name <String[]>] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-Port <Int32>] [-UseSSL] [-SessionOption <PSSessionOption>]
  [-ThrottleLimit <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-PSSession [-ConfigurationName <String>] [-ConnectionUri] <Uri[]> [-AllowRedirection]
  -InstanceId <Guid[]> [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-SessionOption <PSSessionOption>] [-ThrottleLimit
  <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-PSSession [-ConfigurationName <String>] [-ConnectionUri] <Uri[]> [-AllowRedirection]
  [-Name <String[]>] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [-SessionOption <PSSessionOption>] [-ThrottleLimit
  <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-PSSession -InstanceId <Guid[]> [-ThrottleLimit <Int32>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Connect-PSSession [-ThrottleLimit <Int32>] [-Id] <Int32[]> [-WhatIf] [-Confirm]
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
  -ComputerName,-Cn System.String[]:
    required: true
  -ConfigurationName System.String: ~
  -ConnectionUri,-URI,-CU System.Uri[]:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -Id System.Int32[]:
    required: true
  -InstanceId System.Guid[]:
    required: true
  -Name System.String[]: ~
  -Port System.Int32: ~
  -Session System.Management.Automation.Runspaces.PSSession[]:
    required: true
  -SessionOption System.Management.Automation.Remoting.PSSessionOption: ~
  -ThrottleLimit System.Int32: ~
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
