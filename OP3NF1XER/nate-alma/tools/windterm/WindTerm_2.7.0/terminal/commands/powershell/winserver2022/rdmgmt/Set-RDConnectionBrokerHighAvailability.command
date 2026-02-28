description: Sets high availability settings for RD Connection Broker servers for
  a Remote Desktop deployment
synopses:
- Set-RDConnectionBrokerHighAvailability [[-ConnectionBroker] <String>] [-DatabaseConnectionString]
  <String> [[-DatabaseSecondaryConnectionString] <String>] [[-DatabaseFilePath] <String>]
  [-ClientAccessName] <String> [<CommonParameters>]
options:
  -ClientAccessName String:
    required: true
  -ConnectionBroker String: ~
  -DatabaseConnectionString String:
    required: true
  -DatabaseFilePath String: ~
  -DatabaseSecondaryConnectionString String: ~
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
