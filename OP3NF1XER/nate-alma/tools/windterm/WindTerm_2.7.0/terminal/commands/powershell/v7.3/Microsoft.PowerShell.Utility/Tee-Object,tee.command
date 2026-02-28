description: Saves command output in a file or variable and also sends it down the
  pipeline
synopses:
- Tee-Object [-InputObject <PSObject>] [-FilePath] <String> [-Append] [[-Encoding]
  <Encoding>] [<CommonParameters>]
- Tee-Object [-InputObject <PSObject>] -LiteralPath <String> [[-Encoding] <Encoding>]
  [<CommonParameters>]
- Tee-Object [-InputObject <PSObject>] -Variable <String> [<CommonParameters>]
options:
  -Append Switch: ~
  -Encoding System.Text.Encoding:
    values:
    - ASCII
    - BigEndianUnicode
    - OEM
    - Unicode
    - UTF7
    - UTF8
    - UTF8BOM
    - UTF8NoBOM
    - UTF32
  -FilePath,-Path System.String:
    required: true
  -InputObject System.Management.Automation.PSObject: ~
  -LiteralPath,-PSPath,-LP System.String:
    required: true
  -Variable System.String:
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
