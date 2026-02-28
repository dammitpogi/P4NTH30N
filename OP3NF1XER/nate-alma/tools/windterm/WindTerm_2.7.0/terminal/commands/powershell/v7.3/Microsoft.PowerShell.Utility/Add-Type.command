description: Adds a Microsoft .NET class to a PowerShell session
synopses:
- Add-Type [-TypeDefinition] <String> [-Language <Language>] [-ReferencedAssemblies
  <String[]>] [-OutputAssembly <String>] [-OutputType <OutputAssemblyType>] [-PassThru]
  [-IgnoreWarnings] [-CompilerOptions <String[]>] [<CommonParameters>]
- Add-Type [-Name] <String> [-MemberDefinition] <String[]> [-Namespace <String>] [-UsingNamespace
  <String[]>] [-Language <Language>] [-ReferencedAssemblies <String[]>] [-OutputAssembly
  <String>] [-OutputType <OutputAssemblyType>] [-PassThru] [-IgnoreWarnings] [-CompilerOptions
  <String[]>] [<CommonParameters>]
- Add-Type [-Path] <String[]> [-ReferencedAssemblies <String[]>] [-OutputAssembly
  <String>] [-OutputType <OutputAssemblyType>] [-PassThru] [-IgnoreWarnings] [-CompilerOptions
  <String[]>] [<CommonParameters>]
- Add-Type -LiteralPath <String[]> [-ReferencedAssemblies <String[]>] [-OutputAssembly
  <String>] [-OutputType <OutputAssemblyType>] [-PassThru] [-IgnoreWarnings] [-CompilerOptions
  <String[]>] [<CommonParameters>]
- Add-Type -AssemblyName <String[]> [-PassThru] [<CommonParameters>]
options:
  -AssemblyName,-AN System.String[]:
    required: true
  -CompilerOptions System.String[]: ~
  -IgnoreWarnings Switch: ~
  -Language Microsoft.PowerShell.Commands.Language:
    values:
    - CSharp
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -MemberDefinition System.String[]:
    required: true
  -Name System.String:
    required: true
  -Namespace,-NS System.String: ~
  -OutputAssembly,-OA System.String: ~
  -OutputType,-OT Microsoft.PowerShell.Commands.OutputAssemblyType:
    values:
    - ConsoleApplication
    - Library
    - WindowsApplication
  -PassThru Switch: ~
  -Path System.String[]:
    required: true
  -ReferencedAssemblies,-RA System.String[]: ~
  -TypeDefinition System.String:
    required: true
  -UsingNamespace,-Using System.String[]: ~
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
