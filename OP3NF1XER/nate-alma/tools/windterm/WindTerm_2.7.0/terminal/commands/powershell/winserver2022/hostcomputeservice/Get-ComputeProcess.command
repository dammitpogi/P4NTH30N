description: Gets a list of running compute systems from the Hyper-V Host Compute
  Service
synopses:
- Get-ComputeProcess [[-Name] <String[]>] [-Owner <String[]>] [-Type <ComputeProcessType[]>]
  [<CommonParameters>]
- Get-ComputeProcess [-Id] <String[]> [<CommonParameters>]
options:
  -Id String[]:
    required: true
  -Name String[]: ~
  -Owner String[]: ~
  -Type ComputeProcessType[]:
    values:
    - Container
    - VirtualMachine
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
