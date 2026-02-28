description: Assigns a virtual disk to an iSCSI target
synopses:
- Add-IscsiVirtualDiskTargetMapping [-TargetName] <String> [-Path] <String> [-Lun
  <Int32>] [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Credential PSCredential: ~
  -Lun Int32: ~
  -Path,-DevicePath String:
    required: true
  -TargetName String:
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
