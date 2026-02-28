description: Gets PowerShell background jobs that are running in the current session
synopses:
- Get-Job [-IncludeChildJob] [-ChildJobState <JobState>] [-HasMoreData <Boolean>]
  [-Before <DateTime>] [-After <DateTime>] [-Newest <Int32>] [[-Id] <Int32[]>] [<CommonParameters>]
- Get-Job [-IncludeChildJob] [-ChildJobState <JobState>] [-HasMoreData <Boolean>]
  [-Before <DateTime>] [-After <DateTime>] [-Newest <Int32>] [-InstanceId] <Guid[]>
  [<CommonParameters>]
- Get-Job [-IncludeChildJob] [-ChildJobState <JobState>] [-HasMoreData <Boolean>]
  [-Before <DateTime>] [-After <DateTime>] [-Newest <Int32>] [-Name] <String[]> [<CommonParameters>]
- Get-Job [-IncludeChildJob] [-ChildJobState <JobState>] [-HasMoreData <Boolean>]
  [-Before <DateTime>] [-After <DateTime>] [-Newest <Int32>] [-State] <JobState> [<CommonParameters>]
- Get-Job [-IncludeChildJob] [-ChildJobState <JobState>] [-HasMoreData <Boolean>]
  [-Before <DateTime>] [-After <DateTime>] [-Newest <Int32>] [-Command <String[]>]
  [<CommonParameters>]
- Get-Job [-Filter] <Hashtable> [<CommonParameters>]
options:
  -After System.DateTime: ~
  -Before System.DateTime: ~
  -ChildJobState System.Management.Automation.JobState:
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
  -Command System.String[]: ~
  -Filter System.Collections.Hashtable:
    required: true
  -HasMoreData System.Boolean: ~
  -Id System.Int32[]: ~
  -IncludeChildJob Switch: ~
  -InstanceId System.Guid[]:
    required: true
  -Name System.String[]:
    required: true
  -Newest System.Int32: ~
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
