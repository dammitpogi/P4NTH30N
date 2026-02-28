description: Resizes an iSCSI virtual disk
synopses:
- Resize-IscsiVirtualDisk [-Path] <String> [-SizeBytes] <UInt64> [-PassThru] [-ComputerName
  <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Resize-IscsiVirtualDisk -InputObject <IscsiVirtualDisk> [-SizeBytes] <UInt64> [-PassThru]
  [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Credential PSCredential: ~
  -InputObject IscsiVirtualDisk:
    required: true
  -PassThru Switch: ~
  -Path,-DevicePath String:
    required: true
  -SizeBytes,-Size UInt64:
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
