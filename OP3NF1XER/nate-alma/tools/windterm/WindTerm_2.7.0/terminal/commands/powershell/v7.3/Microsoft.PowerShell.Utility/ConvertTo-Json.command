description: Converts an object to a JSON-formatted string
synopses:
- ConvertTo-Json [-InputObject] <Object> [-Depth <Int32>] [-Compress] [-EnumsAsStrings]
  [-AsArray] [-EscapeHandling <StringEscapeHandling>] [<CommonParameters>]
options:
  -AsArray Switch: ~
  -Compress Switch: ~
  -Depth System.Int32: ~
  -EnumsAsStrings Switch: ~
  -EscapeHandling Newtonsoft.Json.StringEscapeHandling: ~
  -InputObject System.Object:
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
