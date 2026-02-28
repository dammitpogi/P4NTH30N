description: Configures load balancing on the Remote Access (RA) server or the cluster
  server
synopses:
- Set-RemoteAccessLoadBalancer [-ComputerName <String>] [-PassThru] [-UseThirdPartyLoadBalancer]
  [-InternetDedicatedIPAddress] <String[]> [-InternalDedicatedIPAddress <String[]>]
  [-InternetVirtualIPAddress <String[]>] [-InternalVirtualIPAddress <String[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-RemoteAccessLoadBalancer [-Disable] [-ComputerName <String>] [-Force] [-PassThru]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-RemoteAccessLoadBalancer [-ComputerName <String>] [-PassThru] -ThirdPartyLoadBalancer
  <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Disable Switch:
    required: true
  -Force Switch: ~
  -InternalDedicatedIPAddress String[]: ~
  -InternalVirtualIPAddress String[]: ~
  -InternetDedicatedIPAddress String[]:
    required: true
  -InternetVirtualIPAddress String[]: ~
  -PassThru Switch: ~
  -ThirdPartyLoadBalancer String:
    required: true
    values:
    - Enabled
    - Disabled
  -ThrottleLimit Int32: ~
  -UseThirdPartyLoadBalancer Switch: ~
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
