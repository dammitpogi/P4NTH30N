description: Imports a boot image to the image store
synopses:
- Import-WdsBootImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] [-SkipVerify] [-NewFileName <String>] -Path <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Import-WdsBootImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] [-SkipVerify] [-NewFileName <String>] [-TransmissionName <String>] [-Multicast]
  -Path <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DisplayOrder UInt32: ~
  -Multicast Switch:
    required: true
  -NewDescription String: ~
  -NewFileName String: ~
  -NewImageName String: ~
  -Path String:
    required: true
  -SkipVerify Switch: ~
  -ThrottleLimit Int32: ~
  -TransmissionName String: ~
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
