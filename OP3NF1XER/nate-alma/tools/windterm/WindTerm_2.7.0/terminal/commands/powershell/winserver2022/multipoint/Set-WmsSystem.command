description: Modifies system properties
synopses:
- Set-WmsSystem [-BootToConsoleMode <Boolean>] [-DesktopMonitoring <Boolean>] [-IM
  <Boolean>] [-IPPerSession <Boolean>] [-Mode <SystemOperatingModePS>] [-SingleSessionPerUser
  <Boolean>] [-SuppressPrivacyNotification <Boolean>] [-AdminOrchestration <Boolean>]
  [-Server <String>] [<CommonParameters>]
options:
  -AdminOrchestration,-IsAdminOrchestrationEnabled Boolean: ~
  -BootToConsoleMode Boolean: ~
  -DesktopMonitoring,-IsDesktopMonitoringAllowed Boolean: ~
  -IM,-IsChatEnabled Boolean: ~
  -IPPerSession,-IsIPPerSessionEnabled Boolean: ~
  -Mode SystemOperatingModePS:
    values:
    - Console
    - MultiStation
  -Server,-ComputerName String: ~
  -SingleSessionPerUser,-IsSingleSessionPerUser Boolean: ~
  -SuppressPrivacyNotification Boolean: ~
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
