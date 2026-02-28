description: Streams the contents of packages to the local disk
synopses:
- Mount-AppvClientConnectionGroup [-GroupId] <Guid> [-VersionId] <Guid> [<CommonParameters>]
- Mount-AppvClientConnectionGroup [-Name] <String> [<CommonParameters>]
- Mount-AppvClientConnectionGroup [-ConnectionGroup] <AppvClientConnectionGroup> [<CommonParameters>]
options:
  -ConnectionGroup AppvClientConnectionGroup:
    required: true
  -GroupId Guid:
    required: true
  -Name String:
    required: true
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
