description: Modifies the frequency of synchronization for the AD FS configuration
  database and which server is primary in the farm
synopses:
- Set-AdfsSyncProperties [-PrimaryComputerName <String>] [-PrimaryComputerPort <Int32>]
  [-PollDuration <Int32>] [-Role <String>] [<CommonParameters>]
options:
  -PollDuration Int32: ~
  -PrimaryComputerName String: ~
  -PrimaryComputerPort Int32: ~
  -Role String: ~
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
