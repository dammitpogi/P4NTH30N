description: Imports commands from another session into the current session
synopses:
- Import-PSSession [-Prefix <String>] [-DisableNameChecking] [[-CommandName] <String[]>]
  [-AllowClobber] [-ArgumentList <Object[]>] [-CommandType <CommandTypes>] [-Module
  <String[]>] [-FullyQualifiedModule <ModuleSpecification[]>] [[-FormatTypeName] <String[]>]
  [-Certificate <X509Certificate2>] [-Session] <PSSession> [<CommonParameters>]
options:
  -AllowClobber Switch: ~
  -ArgumentList,-Args System.Object[]: ~
  -Certificate System.Security.Cryptography.X509Certificates.X509Certificate2: ~
  -CommandName,-Name System.String[]: ~
  -CommandType,-Type System.Management.Automation.CommandTypes:
    values:
    - Alias
    - Function
    - Filter
    - Cmdlet
    - ExternalScript
    - Application
    - Script
    - Workflow
    - Configuration
    - All
  -DisableNameChecking Switch: ~
  -FormatTypeName System.String[]: ~
  -FullyQualifiedModule Microsoft.PowerShell.Commands.ModuleSpecification[]: ~
  -Module,-PSSnapin System.String[]: ~
  -Prefix System.String: ~
  -Session System.Management.Automation.Runspaces.PSSession:
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
