description: Updates the configuration of an existing printer
synopses:
- Set-Printer [-Name] <String[]> [-ComputerName <String>] [-Comment <String>] [-Datatype
  <String>] [-DriverName <String>] [-UntilTime <UInt32>] [-KeepPrintedJobs <Boolean>]
  [-Location <String>] [-PermissionSDDL <String>] [-PortName <String>] [-PrintProcessor
  <String>] [-Priority <UInt32>] [-Published <Boolean>] [-RenderingMode <RenderingModeEnum>]
  [-SeparatorPageFile <String>] [-Shared <Boolean>] [-ShareName <String>] [-StartTime
  <UInt32>] [-DisableBranchOfficeLogging <Boolean>] [-BranchOfficeOfflineLogSizeMB
  <UInt32>] [-WorkflowPolicy <WorkflowPolicyEnum>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Printer -InputObject <CimInstance[]> [-Comment <String>] [-Datatype <String>]
  [-DriverName <String>] [-UntilTime <UInt32>] [-KeepPrintedJobs <Boolean>] [-Location
  <String>] [-PermissionSDDL <String>] [-PortName <String>] [-PrintProcessor <String>]
  [-Priority <UInt32>] [-Published <Boolean>] [-RenderingMode <RenderingModeEnum>]
  [-SeparatorPageFile <String>] [-Shared <Boolean>] [-ShareName <String>] [-StartTime
  <UInt32>] [-DisableBranchOfficeLogging <Boolean>] [-BranchOfficeOfflineLogSizeMB
  <UInt32>] [-WorkflowPolicy <WorkflowPolicyEnum>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BranchOfficeOfflineLogSizeMB UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -Comment String: ~
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -Datatype String: ~
  -DisableBranchOfficeLogging Boolean: ~
  -DriverName String: ~
  -InputObject CimInstance[]:
    required: true
  -KeepPrintedJobs Boolean: ~
  -Location String: ~
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -PermissionSDDL String: ~
  -PortName String: ~
  -PrintProcessor String: ~
  -Priority UInt32: ~
  -Published Boolean: ~
  -RenderingMode RenderingModeEnum:
    values:
    - SSR
    - CSR
    - BranchOffice
  -SeparatorPageFile String: ~
  -ShareName String: ~
  -Shared Boolean: ~
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
