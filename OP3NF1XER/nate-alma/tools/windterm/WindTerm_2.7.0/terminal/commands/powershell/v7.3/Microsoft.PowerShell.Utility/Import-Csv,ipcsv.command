description: Creates table-like custom objects from the items in a comma-separated
  value (CSV) file
synopses:
- Import-Csv [[-Delimiter] <Char>] [-Path] <String[]> [-Header <String[]>] [-Encoding
  <Encoding>] [<CommonParameters>]
- Import-Csv [[-Delimiter] <Char>] -LiteralPath <String[]> [-Header <String[]>] [-Encoding
  <Encoding>] [<CommonParameters>]
- Import-Csv [-Path] <String[]> -UseCulture [-Header <String[]>] [-Encoding <Encoding>]
  [<CommonParameters>]
- Import-Csv -LiteralPath <String[]> -UseCulture [-Header <String[]>] [-Encoding <Encoding>]
  [<CommonParameters>]
options:
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
  -Header System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Path System.String[]:
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
