description: Converts plain text or encrypted strings to secure strings
synopses:
- ConvertTo-SecureString [-String] <String> [[-SecureKey] <SecureString>] [<CommonParameters>]
- ConvertTo-SecureString [-String] <String> [-AsPlainText] [-Force] [<CommonParameters>]
- ConvertTo-SecureString [-String] <String> [-Key <Byte[]>] [<CommonParameters>]
options:
  -AsPlainText Switch: ~
  -Force Switch: ~
  -Key System.Byte[]: ~
  -SecureKey System.Security.SecureString: ~
  -String System.String:
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
