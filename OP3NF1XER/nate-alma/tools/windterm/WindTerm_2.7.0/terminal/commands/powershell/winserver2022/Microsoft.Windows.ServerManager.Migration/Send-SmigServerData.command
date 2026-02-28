description: Migrates folders, files, and associated permissions and share properties
  from a source server to a destination server through port 7000. The cmdlet Receive-SmigServerData
  must be run on the destination server at the same time Send-SmigServerData is running
  on the source server
synopses:
- Send-SmigServerData -ComputerName <String> -Password <SecureString> -Include <MigrationIncludeTypes>
  -DestinationPath <String> [-Force] [-Recurse] -SourcePath <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -ComputerName String:
    required: true
  -DestinationPath String:
    required: true
  -Force Switch: ~
  -Include MigrationIncludeTypes:
    required: true
  -Password SecureString:
    required: true
  -Recurse Switch: ~
  -SourcePath String:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
