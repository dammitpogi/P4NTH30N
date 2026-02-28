description: Converts object properties in comma-separated value (CSV) format into
  CSV versions of the original objects
synopses:
- ConvertFrom-Csv [[-Delimiter] <Char>] [-InputObject] <PSObject[]> [-Header <String[]>]
  [<CommonParameters>]
- ConvertFrom-Csv -UseCulture [-InputObject] <PSObject[]> [-Header <String[]>] [<CommonParameters>]
options:
  -Delimiter System.Char: ~
  -Header System.String[]: ~
  -InputObject System.Management.Automation.PSObject[]:
    required: true
  -UseCulture Switch:
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
