description: Deletes a virtual disk object, without deleting the virtual hard disk
  (VHD) file
synopses:
- Remove-IscsiVirtualDisk [-Path] <String> [-ComputerName <String>] [-Credential <PSCredential>]
  [<CommonParameters>]
- Remove-IscsiVirtualDisk -InputObject <IscsiVirtualDisk> [-ComputerName <String>]
  [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Credential PSCredential: ~
  -InputObject IscsiVirtualDisk:
    required: true
  -Path,-DevicePath String:
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
