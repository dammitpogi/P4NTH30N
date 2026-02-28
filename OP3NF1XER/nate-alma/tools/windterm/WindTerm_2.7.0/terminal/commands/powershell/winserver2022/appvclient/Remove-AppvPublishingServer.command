description: Removes an App-V publishing server
synopses:
- Remove-AppvPublishingServer [-ServerId] <UInt32> [<CommonParameters>]
- Remove-AppvPublishingServer [-Server] <AppvPublishingServer> [<CommonParameters>]
- Remove-AppvPublishingServer [[-Name] <String>] [[-URL] <String>] [<CommonParameters>]
options:
  -Name String: ~
  -Server AppvPublishingServer:
    required: true
  -ServerId UInt32:
    required: true
  -URL String: ~
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
