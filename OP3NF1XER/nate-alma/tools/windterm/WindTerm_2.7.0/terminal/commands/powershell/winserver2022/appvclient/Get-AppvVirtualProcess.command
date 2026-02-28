description: Displays the virtual processes running on a computer
synopses:
- Get-AppvVirtualProcess [[-Name] <String[]>] [-ComputerName <String[]>] [-Module]
  [-FileVersionInfo] [<CommonParameters>]
- Get-AppvVirtualProcess -Id <Int32[]> [-ComputerName <String[]>] [-Module] [-FileVersionInfo]
  [<CommonParameters>]
- Get-AppvVirtualProcess [-ComputerName <String[]>] [-Module] [-FileVersionInfo] -InputObject
  <Process[]> [<CommonParameters>]
options:
  -ComputerName,-Cn String[]: ~
  -FileVersionInfo,-FV,-FVI Switch: ~
  -Id,-PID Int32[]:
    required: true
  -InputObject Process[]:
    required: true
  -Module Switch: ~
  -Name,-ProcessName String[]: ~
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
