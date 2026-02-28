description: Gets content that has been encrypted by using the Cryptographic Message
  Syntax format
synopses:
- Get-CmsMessage [-Content] <String> [<CommonParameters>]
- Get-CmsMessage [-Path] <String> [<CommonParameters>]
- Get-CmsMessage [-LiteralPath] <String> [<CommonParameters>]
options:
  -Content System.String:
    required: true
  -LiteralPath System.String:
    required: true
  -Path System.String:
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
