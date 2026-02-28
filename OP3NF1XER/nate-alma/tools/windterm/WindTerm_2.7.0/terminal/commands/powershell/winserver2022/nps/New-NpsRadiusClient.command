description: Creates a RADIUS client
synopses:
- New-NpsRadiusClient [-Name] <String> [-Address] <String> [-AuthAttributeRequired
  <Boolean>] [-SharedSecret <String>] [-VendorName <String>] [-Disabled] [<CommonParameters>]
options:
  -Address String:
    required: true
  -AuthAttributeRequired Boolean: ~
  -Disabled Switch: ~
  -Name String:
    required: true
  -SharedSecret String: ~
  -VendorName String: ~
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
