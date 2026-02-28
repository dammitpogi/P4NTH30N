description: Creates an FTP 7 Site
synopses:
- New-WebFtpSite [-Name] <String> [-Id <UInt32>] [-Port <UInt32>] [-IPAddress <String>]
  [-HostHeader <String>] [-PhysicalPath <String>] [-Force] [<CommonParameters>]
options:
  -Force Switch: ~
  -HostHeader String: ~
  -IPAddress String: ~
  -Id UInt32: ~
  -Name String:
    required: true
  -PhysicalPath String: ~
  -Port UInt32: ~
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
