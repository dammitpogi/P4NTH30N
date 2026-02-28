description: Resets the user package settings for the connection group
synopses:
- Repair-AppvClientConnectionGroup [-Global] [-UserState] [-Extensions] [-GroupId]
  <Guid> [-VersionId] <Guid> [<CommonParameters>]
- Repair-AppvClientConnectionGroup [-Global] [-UserState] [-Extensions] [-Name] <String>
  [<CommonParameters>]
- Repair-AppvClientConnectionGroup [-Global] [-UserState] [-Extensions] [-ConnectionGroup]
  <AppvClientConnectionGroup> [<CommonParameters>]
options:
  -ConnectionGroup AppvClientConnectionGroup:
    required: true
  -Extensions Switch: ~
  -Global Switch: ~
  -GroupId Guid:
    required: true
  -Name String:
    required: true
  -UserState Switch: ~
  -VersionId Guid:
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
