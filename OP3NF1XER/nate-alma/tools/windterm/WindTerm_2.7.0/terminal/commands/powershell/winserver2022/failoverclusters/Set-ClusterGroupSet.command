description: Updates a cluster group set
synopses:
- Set-ClusterGroupSet [[-Name] <String[]>] [-StartupSetting <StartupSettingType>]
  [-StartupCount <UInt32>] [-IsGlobal <Boolean>] [-StartupDelay <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Set-ClusterGroupSet -InputObject <CimInstance[]> [-StartupSetting <StartupSettingType>]
  [-StartupCount <UInt32>] [-IsGlobal <Boolean>] [-StartupDelay <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InputObject CimInstance[]:
    required: true
  -IsGlobal Boolean: ~
  -Name String[]: ~
  -PassThru Switch: ~
  -StartupCount,-Count UInt32: ~
  -StartupDelay,-Delay UInt32: ~
  -StartupSetting,-StartupDelayTrigger StartupSettingType:
    values:
    - Delay
    - Online
  -ThrottleLimit Int32: ~
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
