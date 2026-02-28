description: Imports the data from a specified .cilx or .cil file into a VAMT database
synopses:
- Import-VamtData -Products <Product[]> [-DbConnectionString <String>] [-DbCommandTimeout
  <Int32>] [<CommonParameters>]
- Import-VamtData -InputFile <String> [-DbConnectionString <String>] [-DbCommandTimeout
  <Int32>] [<CommonParameters>]
options:
  -DbCommandTimeout Int32: ~
  -DbConnectionString String: ~
  -InputFile String:
    required: true
  -Products Product[]:
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
