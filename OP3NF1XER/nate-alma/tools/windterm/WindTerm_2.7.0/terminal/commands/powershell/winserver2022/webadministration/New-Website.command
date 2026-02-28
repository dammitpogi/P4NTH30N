description: Creates an IIS website
synopses:
- New-Website [-Name] <String> [-Id <UInt32>] [-Port <UInt32>] [-IPAddress <String>]
  [-SslFlags <Int32>] [-HostHeader <String>] [-PhysicalPath <String>] [-ApplicationPool
  <String>] [-Ssl] [-Force] [<CommonParameters>]
options:
  -ApplicationPool String: ~
  -Force Switch: ~
  -HostHeader String: ~
  -IPAddress String: ~
  -Id UInt32: ~
  -Name String:
    required: true
  -PhysicalPath String: ~
  -Port UInt32: ~
  -Ssl Switch: ~
  -SslFlags Int32: ~
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
