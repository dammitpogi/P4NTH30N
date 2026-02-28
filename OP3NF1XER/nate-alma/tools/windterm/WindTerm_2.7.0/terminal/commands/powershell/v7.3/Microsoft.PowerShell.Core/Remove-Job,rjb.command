description: Deletes a PowerShell background job
synopses:
- Remove-Job [-Force] [-Id] <Int32[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-Job [-Job] <Job[]> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-Job [-Force] [-Name] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-Job [-Force] [-InstanceId] <Guid[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-Job [-Force] [-Filter] <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-Job [-State] <JobState> [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-Job [-Command <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Command System.String[]: ~
  -Filter System.Collections.Hashtable:
    required: true
  -Force,-F Switch: ~
  -Id System.Int32[]:
    required: true
  -InstanceId System.Guid[]:
    required: true
  -Job System.Management.Automation.Job[]:
    required: true
  -Name System.String[]:
    required: true
  -State System.Management.Automation.JobState:
    required: true
    values:
    - AtBreakpoint
    - Blocked
    - Completed
    - Disconnected
    - Failed
    - NotStarted
    - Running
    - Stopped
    - Stopping
    - Suspended
    - Suspending
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
