description: Waits until one or all of the PowerShell jobs running in the session
  are in a terminating state
synopses:
- Wait-Job [-Any] [-Timeout <Int32>] [-Force] [-Id] <Int32[]> [<CommonParameters>]
- Wait-Job [-Job] <Job[]> [-Any] [-Timeout <Int32>] [-Force] [<CommonParameters>]
- Wait-Job [-Any] [-Timeout <Int32>] [-Force] [-Name] <String[]> [<CommonParameters>]
- Wait-Job [-Any] [-Timeout <Int32>] [-Force] [-InstanceId] <Guid[]> [<CommonParameters>]
- Wait-Job [-Any] [-Timeout <Int32>] [-Force] [-State] <JobState> [<CommonParameters>]
- Wait-Job [-Any] [-Timeout <Int32>] [-Force] [-Filter] <Hashtable> [<CommonParameters>]
options:
  -Any Switch: ~
  -Filter System.Collections.Hashtable:
    required: true
  -Force Switch: ~
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
    - NotStarted
    - Running
    - Completed
    - Failed
    - Stopped
    - Blocked
    - Suspended
    - Disconnected
    - Suspending
    - Stopping
    - AtBreakpoint
  -Timeout,-TimeoutSec System.Int32: ~
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
