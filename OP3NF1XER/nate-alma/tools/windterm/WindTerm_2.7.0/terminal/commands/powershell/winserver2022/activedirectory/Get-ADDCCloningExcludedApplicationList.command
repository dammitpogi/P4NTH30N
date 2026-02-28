description: Gets a list of installed programs and services present on this domain
  controller that are not in the default or user defined inclusion list
synopses:
- Get-ADDCCloningExcludedApplicationList [<CommonParameters>]
- Get-ADDCCloningExcludedApplicationList [-Force] [-GenerateXml] [-Path <String>]
  [<CommonParameters>]
options:
  -Force Switch: ~
  -GenerateXml Switch:
    required: true
  -Path String: ~
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
