description: Gets the UE-V configuration settings
synopses:
- Get-UevConfiguration [<CommonParameters>]
- Get-UevConfiguration [-Computer] [<CommonParameters>]
- Get-UevConfiguration [-CurrentComputerUser] [<CommonParameters>]
- Get-UevConfiguration [-Details] [<CommonParameters>]
options:
  -Computer Switch:
    required: true
  -CurrentComputerUser Switch:
    required: true
  -Details Switch:
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
