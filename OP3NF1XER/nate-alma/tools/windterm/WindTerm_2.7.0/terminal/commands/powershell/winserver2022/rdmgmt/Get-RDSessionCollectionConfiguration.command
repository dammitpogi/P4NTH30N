description: Gets configuration information for a session collection
synopses:
- Get-RDSessionCollectionConfiguration [-CollectionName] <String> [-ConnectionBroker
  <String>] [<CommonParameters>]
- Get-RDSessionCollectionConfiguration [-CollectionName] <String> [-UserGroup] [-ConnectionBroker
  <String>] [<CommonParameters>]
- Get-RDSessionCollectionConfiguration [-CollectionName] <String> [-Connection] [-ConnectionBroker
  <String>] [<CommonParameters>]
- Get-RDSessionCollectionConfiguration [-CollectionName] <String> [-UserProfileDisk]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Get-RDSessionCollectionConfiguration [-CollectionName] <String> [-Security] [-ConnectionBroker
  <String>] [<CommonParameters>]
- Get-RDSessionCollectionConfiguration [-CollectionName] <String> [-LoadBalancing]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Get-RDSessionCollectionConfiguration [-CollectionName] <String> [-Client] [-ConnectionBroker
  <String>] [<CommonParameters>]
options:
  -Client Switch:
    required: true
  -CollectionName String:
    required: true
  -Connection Switch:
    required: true
  -ConnectionBroker String: ~
  -LoadBalancing Switch:
    required: true
  -Security Switch:
    required: true
  -UserGroup Switch:
    required: true
  -UserProfileDisk Switch:
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
