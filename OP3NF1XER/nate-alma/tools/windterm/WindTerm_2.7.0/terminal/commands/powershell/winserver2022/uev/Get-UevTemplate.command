description: Gets settings location templates for UE-V
synopses:
- Get-UevTemplate [<CommonParameters>]
- Get-UevTemplate -Application <String> [<CommonParameters>]
- Get-UevTemplate -TemplateID <String> [<CommonParameters>]
- Get-UevTemplate -Profile <String> [<CommonParameters>]
- Get-UevTemplate [-ApplicationOrTemplateID] <String> [<CommonParameters>]
options:
  -Application String:
    required: true
  -ApplicationOrTemplateID String:
    required: true
  -Profile String:
    required: true
  -TemplateID String:
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
