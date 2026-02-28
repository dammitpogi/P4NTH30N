description: Gets all commands
synopses:
- Get-Command [-Verb <String[]>] [-Noun <String[]>] [-Module <String[]>] [-FullyQualifiedModule
  <ModuleSpecification[]>] [-TotalCount <Int32>] [-Syntax] [-ShowCommandInfo] [[-ArgumentList]
  <Object[]>] [-All] [-ListImported] [-ParameterName <String[]>] [-ParameterType <PSTypeName[]>]
  [<CommonParameters>]
- Get-Command [[-Name] <String[]>] [-Module <String[]>] [-FullyQualifiedModule <ModuleSpecification[]>]
  [-CommandType <CommandTypes>] [-TotalCount <Int32>] [-Syntax] [-ShowCommandInfo]
  [[-ArgumentList] <Object[]>] [-All] [-ListImported] [-ParameterName <String[]>]
  [-ParameterType <PSTypeName[]>] [-UseFuzzyMatching] [-UseAbbreviationExpansion]
  [<CommonParameters>]
options:
  -All Switch: ~
  -ArgumentList,-Args System.Object[]: ~
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
  -FullyQualifiedModule Microsoft.PowerShell.Commands.ModuleSpecification[]: ~
  -ListImported Switch: ~
  -Module,-PSSnapin System.String[]: ~
  -Name System.String[]: ~
  -Noun System.String[]: ~
  -ParameterName System.String[]: ~
  -ParameterType System.Management.Automation.PSTypeName[]: ~
  -ShowCommandInfo Switch: ~
  -Syntax Switch: ~
  -TotalCount System.Int32: ~
  -UseAbbreviationExpansion Switch: ~
  -UseFuzzyMatching Switch: ~
  -Verb System.String[]: ~
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
