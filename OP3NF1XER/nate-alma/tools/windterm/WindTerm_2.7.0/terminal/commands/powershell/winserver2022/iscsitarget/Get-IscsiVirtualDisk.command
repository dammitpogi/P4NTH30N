description: Obtains the iSCSI virtual disks and their associated properties
synopses:
- Get-IscsiVirtualDisk [-ClusterGroupName <String>] [[-Path] <String>] [-ComputerName
  <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Get-IscsiVirtualDisk [-ClusterGroupName <String>] [-TargetName <String>] [-ComputerName
  <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Get-IscsiVirtualDisk [-ClusterGroupName <String>] [-InitiatorId <InitiatorId>] [-ComputerName
  <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ClusterGroupName String: ~
  -ComputerName String: ~
  -Credential PSCredential: ~
  -InitiatorId InitiatorId: ~
  -Path,-DevicePath String: ~
  -TargetName String: ~
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
