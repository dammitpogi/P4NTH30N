description: Retrieves the list of pending file updates between two DFS Replication
  partners
synopses:
- Get-DfsrBacklog [[-GroupName] <String[]>] [[-FolderName] <String[]>] [-SourceComputerName]
  <String> [-DestinationComputerName] <String> [<CommonParameters>]
options:
  -DestinationComputerName,-ReceivingMember,-RMem String:
    required: true
  -FolderName,-RF,-RfName String[]: ~
  -GroupName,-RG,-RgName String[]: ~
  -SourceComputerName,-SendingMember,-SMem String:
    required: true
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
