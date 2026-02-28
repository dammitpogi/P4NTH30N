description: Update an existing cluster fault domain
synopses:
- Set-ClusterFaultDomain [[-Name] <String[]>] [-Id <String[]>] [-NewName <String>]
  [-Location <String>] [-Description <String>] [-FaultDomain <String>] [-Flags <UInt32>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Set-ClusterFaultDomain -InputObject <CimInstance[]> [-NewName <String>] [-Location
  <String>] [-Description <String>] [-FaultDomain <String>] [-Flags <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Description String: ~
  -FaultDomain,-Parent String: ~
  -Flags UInt32: ~
  -Id String[]: ~
  -InputObject CimInstance[]:
    required: true
  -Location String: ~
  -Name String[]: ~
  -NewName String: ~
  -PassThru Switch: ~
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
