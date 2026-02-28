description: Exports an event trace log file for provisioning
synopses:
- Export-Trace [-ETLFile] <String> [-Overwrite] [-LogsDirectoryPath <String>] [-WprpFile
  <String>] [-ConnectedDevice] [<CommonParameters>]
options:
  -ConnectedDevice,-Device Switch: ~
  -ETLFile,-Etl String:
    required: true
  -LogsDirectoryPath,-Logs String: ~
  -Overwrite,-Force,-Overwrite Switch: ~
  -WprpFile,-Wprp String: ~
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
