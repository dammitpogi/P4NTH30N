description: Creates an iSCSI virtual disk with the specified file path and size
synopses:
- New-IscsiVirtualDisk [-Description <String>] [-Path] <String> [-SizeBytes] <UInt64>
  [-LogicalSectorSizeBytes <UInt32>] [-PhysicalSectorSizeBytes <UInt32>] [-BlockSizeBytes
  <UInt32>] [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
- New-IscsiVirtualDisk [-Description <String>] -ParentPath <String> [-Path] <String>
  [[-SizeBytes] <UInt64>] [-PhysicalSectorSizeBytes <UInt32>] [-BlockSizeBytes <UInt32>]
  [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
- New-IscsiVirtualDisk [-Description <String>] [-Path] <String> [-SizeBytes] <UInt64>
  [-DoNotClearData] [-UseFixed] [-LogicalSectorSizeBytes <UInt32>] [-PhysicalSectorSizeBytes
  <UInt32>] [-BlockSizeBytes <UInt32>] [-ComputerName <String>] [-Credential <PSCredential>]
  [<CommonParameters>]
options:
  -BlockSizeBytes UInt32: ~
  -ComputerName String: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DoNotClearData Switch: ~
  -LogicalSectorSizeBytes UInt32: ~
  -ParentPath String:
    required: true
  -Path,-DevicePath String:
    required: true
  -PhysicalSectorSizeBytes UInt32: ~
  -SizeBytes,-Size UInt64:
    required: true
  -UseFixed,-Fixed Switch:
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
