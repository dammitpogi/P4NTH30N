description: Retrieves the NAT64 configuration of a computer
synopses:
- Get-NetNatTransitionConfiguration [-InstanceName <String[]>] [-PolicyStore <PolicyStore[]>]
  [-Adapter <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -Adapter CimInstance: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InstanceName String[]: ~
  -PolicyStore,-Store PolicyStore[]:
    values:
    - PersistentStore
    - ActiveStore
  -ThrottleLimit Int32: ~
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
