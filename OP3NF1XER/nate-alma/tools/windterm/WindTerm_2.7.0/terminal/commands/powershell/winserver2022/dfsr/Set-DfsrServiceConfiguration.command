description: Modifies settings for the DFS Replication service
synopses:
- Set-DfsrServiceConfiguration [[-ComputerName] <String[]>] [[-RPCPort] <UInt32>]
  [[-DisableDebugLog] <Boolean>] [[-MaximumDebugLogFiles] <UInt32>] [[-DebugLogPath]
  <String>] [[-DebugLogSeverity] <UInt32>] [[-MaximumDebugLogMessages] <UInt32>] [[-UnexpectedAutoRecovery]
  <Boolean>] [[-CleanupStagingFolderAtPercent] <UInt32>] [[-CleanupStagingFolderUntilPercent]
  <UInt32>] [[-CleanupConflictFolderAtPercent] <UInt32>] [[-CleanupConflictFolderUntilPercent]
  <UInt32>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CleanupConflictFolderAtPercent UInt32: ~
  -CleanupConflictFolderUntilPercent UInt32: ~
  -CleanupStagingFolderAtPercent UInt32: ~
  -CleanupStagingFolderUntilPercent UInt32: ~
  -ComputerName,-MemberList,-MemList String[]: ~
  -Confirm,-cf Switch: ~
  -DebugLogPath String: ~
  -DebugLogSeverity UInt32: ~
  -DisableDebugLog Boolean: ~
  -MaximumDebugLogFiles UInt32: ~
  -MaximumDebugLogMessages UInt32: ~
  -RPCPort UInt32: ~
  -UnexpectedAutoRecovery Boolean: ~
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
