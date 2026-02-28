description: Configures the database connection string for the database server used
  in a high availability environment
synopses:
- Set-RDDatabaseConnectionString [[-DatabaseConnectionString] <String>] [[-DatabaseSecondaryConnectionString]
  <String>] [[-ConnectionBroker] <String>] [-RestoreDatabaseConnection] [-RestoreDBConnectionOnAllBrokers]
  [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -DatabaseConnectionString String: ~
  -DatabaseSecondaryConnectionString String: ~
  -RestoreDatabaseConnection Switch: ~
  -RestoreDBConnectionOnAllBrokers Switch: ~
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
