description: Combines objects from the pipeline into a single string
synopses:
- Join-String [[-Property] <PSPropertyExpression>] [[-Separator] <String>] [-OutputPrefix
  <String>] [-OutputSuffix <String>] [-UseCulture] [-InputObject <PSObject[]>] [<CommonParameters>]
- Join-String [[-Property] <PSPropertyExpression>] [[-Separator] <String>] [-OutputPrefix
  <String>] [-OutputSuffix <String>] [-SingleQuote] [-UseCulture] [-InputObject <PSObject[]>]
  [<CommonParameters>]
- Join-String [[-Property] <PSPropertyExpression>] [[-Separator] <String>] [-OutputPrefix
  <String>] [-OutputSuffix <String>] [-DoubleQuote] [-UseCulture] [-InputObject <PSObject[]>]
  [<CommonParameters>]
- Join-String [[-Property] <PSPropertyExpression>] [[-Separator] <String>] [-OutputPrefix
  <String>] [-OutputSuffix <String>] [-FormatString <String>] [-UseCulture] [-InputObject
  <PSObject[]>] [<CommonParameters>]
options:
  -DoubleQuote Switch: ~
  -FormatString System.String: ~
  -InputObject System.Management.Automation.PSObject[]: ~
  -OutputPrefix,-op System.String: ~
  -OutputSuffix,-os System.String: ~
  -Property Microsoft.PowerShell.Commands.PSPropertyExpression: ~
  -Separator System.String: ~
  -SingleQuote Switch: ~
  -UseCulture Switch: ~
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
