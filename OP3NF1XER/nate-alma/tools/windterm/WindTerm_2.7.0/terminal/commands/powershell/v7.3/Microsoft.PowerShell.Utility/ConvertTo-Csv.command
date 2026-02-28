description: Converts .NET objects into a series of character-separated value (CSV)
  strings
synopses:
- ConvertTo-Csv [-InputObject] <PSObject> [[-Delimiter] <Char>] [-IncludeTypeInformation]
  [-NoTypeInformation] [-QuoteFields <String[]>] [-UseQuotes <QuoteKind>] [<CommonParameters>]
- ConvertTo-Csv [-InputObject] <PSObject> [-UseCulture] [-IncludeTypeInformation]
  [-NoTypeInformation] [-QuoteFields <String[]>] [-UseQuotes <QuoteKind>] [<CommonParameters>]
options:
  -Delimiter System.Char: ~
  -IncludeTypeInformation,-ITI Switch: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -NoTypeInformation,-NTI Switch: ~
  -QuoteFields,-QF System.String[]: ~
  -UseCulture Switch: ~
  -UseQuotes,-UQ Microsoft.PowerShell.Commands.BaseCsvWritingCommand+QuoteKind: ~
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
