description: Starts a PowerShell background job
synopses:
- Start-Job [-Name <String>] [-ScriptBlock] <ScriptBlock> [-Credential <PSCredential>]
  [-Authentication <AuthenticationMechanism>] [[-InitializationScript] <ScriptBlock>]
  [-WorkingDirectory <String>] [-RunAs32] [-PSVersion <Version>] [-InputObject <PSObject>]
  [-ArgumentList <Object[]>] [<CommonParameters>]
- Start-Job [-DefinitionName] <String> [[-DefinitionPath] <String>] [[-Type] <String>]
  [-WorkingDirectory <String>] [<CommonParameters>]
- Start-Job [-Name <String>] [-Credential <PSCredential>] [-FilePath] <String> [-Authentication
  <AuthenticationMechanism>] [[-InitializationScript] <ScriptBlock>] [-WorkingDirectory
  <String>] [-RunAs32] [-PSVersion <Version>] [-InputObject <PSObject>] [-ArgumentList
  <Object[]>] [<CommonParameters>]
- Start-Job [-Name <String>] [-Credential <PSCredential>] -LiteralPath <String> [-Authentication
  <AuthenticationMechanism>] [[-InitializationScript] <ScriptBlock>] [-WorkingDirectory
  <String>] [-RunAs32] [-PSVersion <Version>] [-InputObject <PSObject>] [-ArgumentList
  <Object[]>] [<CommonParameters>]
options:
  -ArgumentList,-Args System.Object[]: ~
  -Authentication System.Management.Automation.Runspaces.AuthenticationMechanism:
    values:
    - Default
    - Basic
    - Negotiate
    - NegotiateWithImplicitCredential
    - Credssp
    - Digest
    - Kerberos
  -Credential System.Management.Automation.PSCredential: ~
  -DefinitionName System.String:
    required: true
  -DefinitionPath System.String: ~
  -FilePath System.String:
    required: true
  -InitializationScript System.Management.Automation.ScriptBlock: ~
  -InputObject System.Management.Automation.PSObject: ~
  -LiteralPath,-PSPath,-LP System.String:
    required: true
  -Name System.String: ~
  -PSVersion System.Version: ~
  -RunAs32 Switch: ~
  -ScriptBlock,-Command System.Management.Automation.ScriptBlock:
    required: true
  -Type System.String: ~
  -WorkingDirectory System.String: ~
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
