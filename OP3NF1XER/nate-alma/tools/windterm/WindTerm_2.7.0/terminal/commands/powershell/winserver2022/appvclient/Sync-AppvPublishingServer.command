description: Initiates the App-V Publishing Refresh operation
synopses:
- Sync-AppvPublishingServer [-ServerId] <UInt32> [-Global] [-Force] [-NetworkCostAware]
  [-HidePublishingRefreshUI] [<CommonParameters>]
- Sync-AppvPublishingServer [-Server] <AppvPublishingServer> [-Global] [-Force] [-NetworkCostAware]
  [-HidePublishingRefreshUI] [<CommonParameters>]
- Sync-AppvPublishingServer [[-Name] <String>] [[-URL] <String>] [-Global] [-Force]
  [-NetworkCostAware] [-HidePublishingRefreshUI] [<CommonParameters>]
options:
  -Force Switch: ~
  -Global Switch: ~
  -HidePublishingRefreshUI Switch: ~
  -Name String: ~
  -NetworkCostAware Switch: ~
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
