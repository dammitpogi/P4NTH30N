description: Gets personal session desktop assignments
synopses:
- Get-RDPersonalSessionDesktopAssignment [-CollectionName] <String> [-ConnectionBroker
  <String>] [<CommonParameters>]
- Get-RDPersonalSessionDesktopAssignment [-CollectionName] <String> -Name <String>
  [-ConnectionBroker <String>] [<CommonParameters>]
- Get-RDPersonalSessionDesktopAssignment [-CollectionName] <String> -User <String>
  [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -Name String:
    required: true
  -User String:
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
