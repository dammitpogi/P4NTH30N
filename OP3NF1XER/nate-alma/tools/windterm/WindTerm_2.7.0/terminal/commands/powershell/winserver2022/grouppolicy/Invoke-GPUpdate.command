description: Schedules a remote Group Policy refresh on the specified computer
synopses:
- Invoke-GPUpdate [-AsJob] [-Boot] [[-Computer] <String>] [[-RandomDelayInMinutes]
  <Int32>] [-Force] [-LogOff] [-Target <String>] [<CommonParameters>]
- Invoke-GPUpdate [-AsJob] [-Boot] [[-Computer] <String>] [[-RandomDelayInMinutes]
  <Int32>] [-LogOff] [-Target <String>] [-Sync] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -Boot Switch: ~
  -Computer,-DNSHostName String: ~
  -Force Switch: ~
  -LogOff Switch: ~
  -RandomDelayInMinutes,-RandomnessInMinutes Int32: ~
  -Sync Switch: ~
  -Target String: ~
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
