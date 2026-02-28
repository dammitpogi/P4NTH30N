description: Creates a new iSCSI Target object with the specified name
synopses:
- New-IscsiServerTarget [-TargetName] <String> [-InitiatorIds <InitiatorId[]>] [-ClusterGroupName
  <String>] [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ClusterGroupName String: ~
  -ComputerName String: ~
  -Credential PSCredential: ~
  -InitiatorIds InitiatorId[]: ~
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
