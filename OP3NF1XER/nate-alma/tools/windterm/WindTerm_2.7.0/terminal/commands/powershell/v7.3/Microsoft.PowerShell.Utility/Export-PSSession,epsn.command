description: Exports commands from another session and saves them in a PowerShell
  module
synopses:
- Export-PSSession [-OutputModule] <String> [-Force] [-Encoding <Encoding>] [[-CommandName]
  <String[]>] [-AllowClobber] [-ArgumentList <Object[]>] [-CommandType <CommandTypes>]
  [-Module <String[]>] [-FullyQualifiedModule <ModuleSpecification[]>] [[-FormatTypeName]
  <String[]>] [-Certificate <X509Certificate2>] [-Session] <PSSession> [<CommonParameters>]
options:
  -AllowClobber Switch: ~
  -ArgumentList,-Args System.Object[]: ~
  -Certificate System.Security.Cryptography.X509Certificates.X509Certificate2: ~
  -CommandName,-Name System.String[]: ~
  -CommandType,-Type System.Management.Automation.CommandTypes:
    values:
    - Alias
    - All
    - Application
    - Cmdlet
    - Configuration
    - ExternalScript
    - Filter
    - Function
    - Script
    - Workflow
  -Encoding System.Text.Encoding:
    values:
    - ASCII
    - BigEndianUnicode
    - BigEndianUTF32
    - OEM
    - Unicode
    - UTF7
    - UTF8
    - UTF8BOM
    - UTF8NoBOM
    - UTF32
  -Force Switch: ~
  -FormatTypeName System.String[]: ~
  -FullyQualifiedModule Microsoft.PowerShell.Commands.ModuleSpecification[]: ~
  -Module,-PSSnapin System.String[]: ~
  -OutputModule,-PSPath,-ModuleName System.String:
    required: true
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
