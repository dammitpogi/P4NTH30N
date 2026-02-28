description: Displays a file or other input as hexadecimal
synopses:
- Format-Hex [-Path] <String[]> [-Count <Int64>] [-Offset <Int64>] [<CommonParameters>]
- Format-Hex -LiteralPath <String[]> [-Count <Int64>] [-Offset <Int64>] [<CommonParameters>]
- Format-Hex -InputObject <PSObject> [-Encoding <Encoding>] [-Count <Int64>] [-Offset
  <Int64>] [-Raw] [<CommonParameters>]
options:
  -Count System.Int64: ~
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
  -InputObject System.Management.Automation.PSObject:
    required: true
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Offset System.Int64: ~
  -Path System.String[]:
    required: true
  -Raw Switch: ~
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
