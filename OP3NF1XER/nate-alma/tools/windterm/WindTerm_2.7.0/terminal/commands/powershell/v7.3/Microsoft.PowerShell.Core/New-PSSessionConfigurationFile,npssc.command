description: Creates a file that defines a session configuration
synopses:
- New-PSSessionConfigurationFile [-Path] <String> [-SchemaVersion <Version>] [-Guid
  <Guid>] [-Author <String>] [-Description <String>] [-CompanyName <String>] [-Copyright
  <String>] [-SessionType <SessionType>] [-TranscriptDirectory <String>] [-RunAsVirtualAccount]
  [-RunAsVirtualAccountGroups <String[]>] [-MountUserDrive] [-UserDriveMaximumSize
  <Int64>] [-GroupManagedServiceAccount <String>] [-ScriptsToProcess <String[]>] [-RoleDefinitions
  <IDictionary>] [-RequiredGroups <IDictionary>] [-LanguageMode <PSLanguageMode>]
  [-ExecutionPolicy <ExecutionPolicy>] [-PowerShellVersion <Version>] [-ModulesToImport
  <Object[]>] [-VisibleAliases <String[]>] [-VisibleCmdlets <Object[]>] [-VisibleFunctions
  <Object[]>] [-VisibleExternalCommands <String[]>] [-VisibleProviders <String[]>]
  [-AliasDefinitions <IDictionary[]>] [-FunctionDefinitions <IDictionary[]>] [-VariableDefinitions
  <Object>] [-EnvironmentVariables <IDictionary>] [-TypesToProcess <String[]>] [-FormatsToProcess
  <String[]>] [-AssembliesToLoad <String[]>] [-Full] [<CommonParameters>]
options:
  -AliasDefinitions System.Collections.IDictionary[]: ~
  -AssembliesToLoad System.String[]: ~
  -Author System.String: ~
  -CompanyName System.String: ~
  -Copyright System.String: ~
  -Description System.String: ~
  -EnvironmentVariables System.Collections.IDictionary: ~
  -ExecutionPolicy Microsoft.PowerShell.ExecutionPolicy:
    values:
    - Unrestricted
    - RemoteSigned
    - AllSigned
    - Restricted
    - Default
    - Bypass
    - Undefined
  -FormatsToProcess System.String[]: ~
  -Full Switch: ~
  -FunctionDefinitions System.Collections.IDictionary[]: ~
  -GroupManagedServiceAccount System.String: ~
  -Guid System.Guid: ~
  -LanguageMode System.Management.Automation.PSLanguageMode:
    values:
    - FullLanguage
    - RestrictedLanguage
    - NoLanguage
    - ConstrainedLanguage
  -ModulesToImport System.Object[]: ~
  -MountUserDrive Switch: ~
  -Path System.String:
    required: true
  -PowerShellVersion System.Version: ~
  -RequiredGroups System.Collections.IDictionary: ~
  -RoleDefinitions System.Collections.IDictionary: ~
  -RunAsVirtualAccount Switch: ~
  -RunAsVirtualAccountGroups System.String[]: ~
  -SchemaVersion System.Version: ~
  -ScriptsToProcess System.String[]: ~
  -SessionType System.Management.Automation.Remoting.SessionType:
    values:
    - Empty
    - RestrictedRemoteServer
    - Default
  -TranscriptDirectory System.String: ~
  -TypesToProcess System.String[]: ~
  -UserDriveMaximumSize System.Int64: ~
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
