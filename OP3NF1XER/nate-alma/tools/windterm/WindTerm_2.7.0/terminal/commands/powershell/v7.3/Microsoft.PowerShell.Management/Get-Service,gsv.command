description: Gets the services on the computer
synopses:
- Get-Service [[-Name] <String[]>] [-DependentServices] [-RequiredServices] [-Include
  <String[]>] [-Exclude <String[]>] [<CommonParameters>]
- Get-Service [-DependentServices] [-RequiredServices] -DisplayName <String[]> [-Include
  <String[]>] [-Exclude <String[]>] [<CommonParameters>]
- Get-Service [-DependentServices] [-RequiredServices] [-Include <String[]>] [-Exclude
  <String[]>] [-InputObject <ServiceController[]>] [<CommonParameters>]
options:
  -DependentServices,-DS Switch: ~
  -DisplayName System.String[]:
    required: true
  -Exclude System.String[]: ~
  -Include System.String[]: ~
  -InputObject System.ServiceProcess.ServiceController[]: ~
  -Name,-ServiceName System.String[]: ~
  -RequiredServices,-SDO,-ServicesDependedOn Switch: ~
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
