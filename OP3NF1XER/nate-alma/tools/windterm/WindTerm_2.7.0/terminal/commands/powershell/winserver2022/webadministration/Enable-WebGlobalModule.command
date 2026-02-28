description: Enables an IIS module
synopses:
- Enable-WebGlobalModule [-Name] <String> [-Type <String>] [-Precondition <String>]
  [-Force] [-Location <String[]>] [[-PSPath] <String[]>] [<CommonParameters>]
- Enable-WebGlobalModule -InputObject <PSObject> [-Force] [-Location <String[]>] [[-PSPath]
  <String[]>] [<CommonParameters>]
options:
  -Force Switch: ~
  -InputObject PSObject:
    required: true
  -Location String[]: ~
  -Name String:
    required: true
  -PSPath String[]: ~
  -Precondition String: ~
  -Type String: ~
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
