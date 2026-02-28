description: Adds an entry point to a multi-site deployment
synopses:
- Add-DAEntryPoint [-ComputerName <String>] [-ServerGpoName <String>] [-Name] <String>
  [-GslbIP <IPAddress>] [-DeployNat] [-NoPrerequisite] [-PassThru] -RemoteAccessServer
  <String> [-InternalInterface <String>] [-InternetInterface <String>] [-ClientIPv6Prefix
  <String>] -ConnectToAddress <String> [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientIPv6Prefix String: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -ConnectToAddress String:
    required: true
  -DeployNat Switch: ~
  -Force Switch: ~
  -GslbIP IPAddress: ~
  -InternalInterface String: ~
  -InternetInterface String: ~
  -Name,-EntryPointName String:
    required: true
  -NoPrerequisite Switch: ~
  -PassThru Switch: ~
  -RemoteAccessServer String:
    required: true
  -ServerGpoName String: ~
  -ThrottleLimit Int32: ~
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
