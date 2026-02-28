description: Removes the secondary database connection string for the shared database
  server in a high availability environment configuration
synopses:
- Remove-RDDatabaseConnectionString [-DatabaseConnectionString] [[-ConnectionBroker]
  <String>] [-Force] [<CommonParameters>]
- Remove-RDDatabaseConnectionString [-DatabaseSecondaryConnectionString] [[-ConnectionBroker]
  <String>] [-Force] [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -DatabaseConnectionString Switch:
    required: true
  -DatabaseSecondaryConnectionString Switch:
    required: true
  -Force Switch: ~
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
