description: Sets the colors and styles used for rendering Markdown content in the
  console
synopses:
- Set-MarkdownOption [-Header1Color <String>] [-Header2Color <String>] [-Header3Color
  <String>] [-Header4Color <String>] [-Header5Color <String>] [-Header6Color <String>]
  [-Code <String>] [-ImageAltTextForegroundColor <String>] [-LinkForegroundColor <String>]
  [-ItalicsForegroundColor <String>] [-BoldForegroundColor <String>] [-PassThru] [<CommonParameters>]
- Set-MarkdownOption [-PassThru] -Theme <String> [<CommonParameters>]
- Set-MarkdownOption [-PassThru] [-InputObject] <PSObject> [<CommonParameters>]
options:
  -BoldForegroundColor System.String: ~
  -Code System.String: ~
  -Header1Color System.String: ~
  -Header2Color System.String: ~
  -Header3Color System.String: ~
  -Header4Color System.String: ~
  -Header5Color System.String: ~
  -Header6Color System.String: ~
  -ImageAltTextForegroundColor System.String: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -ItalicsForegroundColor System.String: ~
  -LinkForegroundColor System.String: ~
  -PassThru Switch: ~
  -Theme System.String:
    required: true
    values:
    - Dark
    - Light
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
