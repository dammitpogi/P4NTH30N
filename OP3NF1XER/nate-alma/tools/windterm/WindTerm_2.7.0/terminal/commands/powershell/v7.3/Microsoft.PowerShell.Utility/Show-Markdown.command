description: Shows a Markdown file or string in the console in a friendly way using
  VT100 escape sequences or in a browser using HTML
synopses:
- Show-Markdown [-Path] <String[]> [-UseBrowser] [<CommonParameters>]
- Show-Markdown -InputObject <PSObject> [-UseBrowser] [<CommonParameters>]
- Show-Markdown -LiteralPath <String[]> [-UseBrowser] [<CommonParameters>]
options:
  -InputObject System.Management.Automation.PSObject:
    required: true
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Path System.String[]:
    required: true
  -UseBrowser Switch: ~
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
