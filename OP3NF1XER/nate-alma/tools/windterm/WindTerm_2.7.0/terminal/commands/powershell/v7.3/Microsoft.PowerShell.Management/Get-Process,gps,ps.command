description: Gets the processes that are running on the local computer
synopses:
- Get-Process [[-Name] <String[]>] [-Module] [-FileVersionInfo] [<CommonParameters>]
- Get-Process [[-Name] <String[]>] -IncludeUserName [<CommonParameters>]
- Get-Process -Id <Int32[]> [-Module] [-FileVersionInfo] [<CommonParameters>]
- Get-Process -Id <Int32[]> -IncludeUserName [<CommonParameters>]
- Get-Process -InputObject <Process[]> [-Module] [-FileVersionInfo] [<CommonParameters>]
- Get-Process -InputObject <Process[]> -IncludeUserName [<CommonParameters>]
options:
  -FileVersionInfo,-FV,-FVI Switch: ~
  -Id,-PID System.Int32[]:
    required: true
  -IncludeUserName Switch:
    required: true
  -InputObject System.Diagnostics.Process[]:
    required: true
  -Module Switch: ~
  -Name,-ProcessName System.String[]: ~
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
