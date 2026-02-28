description: Creates a file that defines a set of capabilities to be exposed through
  a session configuration
synopses:
- New-PSRoleCapabilityFile [-Path] <String> [-Guid <Guid>] [-Author <String>] [-Description
  <String>] [-CompanyName <String>] [-Copyright <String>] [-ModulesToImport <Object[]>]
  [-VisibleAliases <String[]>] [-VisibleCmdlets <Object[]>] [-VisibleFunctions <Object[]>]
  [-VisibleExternalCommands <String[]>] [-VisibleProviders <String[]>] [-ScriptsToProcess
  <String[]>] [-AliasDefinitions <IDictionary[]>] [-FunctionDefinitions <IDictionary[]>]
  [-VariableDefinitions <Object>] [-EnvironmentVariables <IDictionary>] [-TypesToProcess
  <String[]>] [-FormatsToProcess <String[]>] [-AssembliesToLoad <String[]>] [<CommonParameters>]
options:
  -AliasDefinitions System.Collections.IDictionary[]: ~
  -AssembliesToLoad System.String[]: ~
  -Author System.String: ~
  -CompanyName System.String: ~
  -Copyright System.String: ~
  -Description System.String: ~
  -EnvironmentVariables System.Collections.IDictionary: ~
  -FormatsToProcess System.String[]: ~
  -FunctionDefinitions System.Collections.IDictionary[]: ~
  -Guid System.Guid: ~
  -ModulesToImport System.Object[]: ~
  -Path System.String:
    required: true
  -ScriptsToProcess System.String[]: ~
  -TypesToProcess System.String[]: ~
  -VariableDefinitions System.Object: ~
  -VisibleAliases System.String[]: ~
  -VisibleCmdlets System.Object[]: ~
  -VisibleExternalCommands System.String[]: ~
  -VisibleFunctions System.Object[]: ~
  -VisibleProviders System.String[]: ~
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
