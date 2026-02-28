description: Adds a printer to the specified computer
synopses:
- Add-Printer [-ConnectionName] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-Printer [-Comment <String>] [-Datatype <String>] [-UntilTime <UInt32>] [-KeepPrintedJobs]
  [-Location <String>] [-SeparatorPageFile <String>] [-ComputerName <String>] [-Shared]
  [-ShareName <String>] [-StartTime <UInt32>] [-Name] <String> [-PermissionSDDL <String>]
  [-PrintProcessor <String>] [-Priority <UInt32>] [-Published] [-RenderingMode <RenderingModeEnum>]
  [-DisableBranchOfficeLogging] [-BranchOfficeOfflineLogSizeMB <UInt32>] [-WorkflowPolicy
  <WorkflowPolicyEnum>] [-DeviceURL <String>] [-DeviceUUID <String>] [-IppURL <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-Printer [-Comment <String>] [-Datatype <String>] [-DriverName] <String> [-UntilTime
  <UInt32>] [-KeepPrintedJobs] [-Location <String>] [-SeparatorPageFile <String>]
  [-ComputerName <String>] [-Shared] [-ShareName <String>] [-StartTime <UInt32>] [-Name]
  <String> [-PermissionSDDL <String>] [-PrintProcessor <String>] [-Priority <UInt32>]
  [-Published] [-RenderingMode <RenderingModeEnum>] -PortName <String> [-DisableBranchOfficeLogging]
  [-BranchOfficeOfflineLogSizeMB <UInt32>] [-WorkflowPolicy <WorkflowPolicyEnum>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BranchOfficeOfflineLogSizeMB UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -Comment String: ~
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -ConnectionName String:
    required: true
  -Datatype String: ~
  -DeviceURL String: ~
  -DeviceUUID String: ~
  -DisableBranchOfficeLogging Switch: ~
  -DriverName String:
    required: true
  -IppURL String: ~
  -KeepPrintedJobs Switch: ~
  -Location String: ~
  -Name String:
    required: true
  -PermissionSDDL String: ~
  -PortName String:
    required: true
  -PrintProcessor String: ~
  -Priority UInt32: ~
  -Published Switch: ~
  -RenderingMode RenderingModeEnum:
    values:
    - SSR
    - CSR
    - BranchOffice
  -SeparatorPageFile String: ~
  -Shared Switch: ~
  -ShareName String: ~
  -StartTime UInt32: ~
  -ThrottleLimit Int32: ~
  -UntilTime UInt32: ~
  -WorkflowPolicy WorkflowPolicyEnum:
    values:
    - Uninitialized
    - Disabled
    - Enabled
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
