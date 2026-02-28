description: Gets session information
synopses:
- Get-WmsSession [-SessionId] <UInt32[]> [-Thumbnail <ThumbnailSizePS>] [-Server <String>]
  [<CommonParameters>]
- Get-WmsSession [-All] [-Thumbnail <ThumbnailSizePS>] [-Server <String>] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -Server,-ComputerName String: ~
  -SessionId UInt32[]:
    required: true
  -Thumbnail ThumbnailSizePS:
    values:
    - Small
    - Medium
    - Large
    - FullScreen
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
