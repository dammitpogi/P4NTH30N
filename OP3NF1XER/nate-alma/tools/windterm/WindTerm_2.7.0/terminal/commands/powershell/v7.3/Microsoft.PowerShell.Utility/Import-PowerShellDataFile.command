description: Imports values from a `.PSD1` file without invoking its contents
synopses:
- Import-PowerShellDataFile [-Path] <String[]> [-SkipLimitCheck] [<CommonParameters>]
- Import-PowerShellDataFile [-LiteralPath] <String[]> [-SkipLimitCheck] [<CommonParameters>]
options:
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Path System.String[]:
    required: true
  -SkipLimitCheck Switch: ~
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
