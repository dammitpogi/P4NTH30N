description: Performs VAMT discovery operations
synopses:
- Find-VamtManagedMachine -QueryType <DiscoveryType> -QueryValue <String> [-MachineFilter
  <String>] [-DbConnectionString <String>] [-Username <String>] [-Password <String>]
  [-DbCommandTimeout <Int32>] [<CommonParameters>]
options:
  -DbCommandTimeout Int32: ~
  -DbConnectionString String: ~
  -MachineFilter String: ~
  -Password String: ~
  -QueryType DiscoveryType:
    required: true
  -QueryValue String:
    required: true
  -Username String: ~
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
