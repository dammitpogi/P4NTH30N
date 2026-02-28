description: Creates a session collection of RD Session Host servers
synopses:
- New-RDSessionCollection [-CollectionName] <String> [-CollectionDescription <String>]
  -SessionHost <String[]> [-ConnectionBroker <String>] [-PersonalUnmanaged] [-AutoAssignUser]
  [-GrantAdministrativePrivilege] [<CommonParameters>]
- New-RDSessionCollection [-CollectionName] <String> [-CollectionDescription <String>]
  -SessionHost <String[]> [-ConnectionBroker <String>] [-PooledUnmanaged] [<CommonParameters>]
options:
  -AutoAssignUser Switch: ~
  -CollectionDescription String: ~
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -GrantAdministrativePrivilege Switch: ~
  -PersonalUnmanaged Switch:
    required: true
  -PooledUnmanaged Switch: ~
  -SessionHost String[]:
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
