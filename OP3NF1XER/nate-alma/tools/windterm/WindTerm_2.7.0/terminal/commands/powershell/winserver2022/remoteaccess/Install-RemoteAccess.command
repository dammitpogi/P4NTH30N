description: Performs prerequisite checks for DirectAccess (DA) to ensure that it
  can be installed, installs DA for remote access (RA) (includes management of remote
  clients) or for management of remote clients only, installs VPN (both Remote Access
  VPN and site-to-site VPN), and installs Border Gateway Protocol Routing.
synopses:
- Install-RemoteAccess [-ComputerName <String>] [-DAInstallType] <String> [-ClientGpoName
  <String>] [-InternalInterface <String>] [-InternetInterface <String>] [-NlsCertificate
  <X509Certificate2>] [-NlsUrl <String>] [-NoPrerequisite] [-ServerGpoName <String>]
  [-ConnectToAddress] <String> [-DeployNat] [-PassThru] [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-RemoteAccess [-ComputerName <String>] [-PassThru] [-VpnType] <String> [-MsgAuthenticator
  <String>] [-RadiusPort <UInt16>] [-RadiusScore <Byte>] [-RadiusServer <String>]
  [-RadiusTimeout <UInt32>] [-SharedSecret <String>] [-Legacy] [-IPAddressRange <String[]>]
  [-IPv6Prefix <String>] [-EntrypointName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-RemoteAccess [-ComputerName <String>] [-PassThru] [-MultiTenancy] [[-VpnType]
  <String>] [-MsgAuthenticator <String>] [-RadiusPort <UInt16>] [-RadiusScore <Byte>]
  [-RadiusServer <String>] [-RadiusTimeout <UInt32>] [-SharedSecret <String>] [-CapacityKbps
  <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Install-RemoteAccess [-ComputerName <String>] [-Prerequisite] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CapacityKbps UInt64: ~
  -CimSession,-Session CimSession[]: ~
  -ClientGpoName,-GpoName String: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -ConnectToAddress String:
    required: true
  -DAInstallType String:
    required: true
    values:
    - FullInstall
    - ManageOut
  -DeployNat Switch: ~
  -EntrypointName String: ~
  -Force Switch: ~
  -IPAddressRange String[]: ~
  -IPv6Prefix String: ~
  -InternalInterface String: ~
  -InternetInterface String: ~
  -Legacy Switch: ~
  -MsgAuthenticator String:
    values:
    - Enabled
    - Disabled
  -MultiTenancy Switch:
    required: true
  -NlsCertificate,-Certificate X509Certificate2: ~
  -NlsUrl String: ~
  -NoPrerequisite Switch: ~
  -PassThru Switch: ~
  -Prerequisite Switch:
    required: true
  -RadiusPort,-Port UInt16: ~
  -RadiusScore,-Score Byte: ~
  -RadiusServer,-ServerName String: ~
  -RadiusTimeout,-Timeout UInt32: ~
  -ServerGpoName String: ~
  -SharedSecret String: ~
  -ThrottleLimit Int32: ~
  -VpnType,-RoleType String:
    required: true
    values:
    - Vpn
    - VpnS2S
    - SstpProxy
    - RoutingOnly
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
