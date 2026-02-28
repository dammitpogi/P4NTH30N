description: Converts objects into a series of comma-separated value (CSV) strings
  and saves the strings to a file
synopses:
- Export-Csv -InputObject <PSObject> [[-Path] <String>] [-LiteralPath <String>] [-Force]
  [-NoClobber] [-Encoding <Encoding>] [-Append] [[-Delimiter] <Char>] [-IncludeTypeInformation]
  [-NoTypeInformation] [-QuoteFields <String[]>] [-UseQuotes <QuoteKind>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Export-Csv -InputObject <PSObject> [[-Path] <String>] [-LiteralPath <String>] [-Force]
  [-NoClobber] [-Encoding <Encoding>] [-Append] [-UseCulture] [-IncludeTypeInformation]
  [-NoTypeInformation] [-QuoteFields <String[]>] [-UseQuotes <QuoteKind>] [-WhatIf]
  [-Confirm]  [<CommonParameters>]
options:
  -Append Switch: ~
  -Delimiter System.Char: ~
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
  -IncludeTypeInformation,-ITI Switch: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -LiteralPath,-PSPath,-LP System.String: ~
  -NoClobber,-NoOverwrite Switch: ~
  -NoTypeInformation,-NTI Switch: ~
  -Path System.String: ~
  -QuoteFields,-QF System.String[]: ~
  -UseCulture Switch: ~
  -UseQuotes,-UQ Microsoft.PowerShell.Commands.BaseCsvWritingCommand+QuoteKind: ~
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
