description: Changes the configuration settings of an existing VPN connection profile
synopses:
- Set-VpnConnection [-Name] <String> [[-ServerAddress] <String>] [-AllUserConnection]
  [[-SplitTunneling] <Boolean>] [[-RememberCredential] <Boolean>] [[-TunnelType] <String>]
  [-PassThru] [-Force] [[-L2tpPsk] <String>] [[-AuthenticationMethod] <String[]>]
  [[-EapConfigXmlStream] <XmlDocument>] [[-UseWinlogonCredential] <Boolean>] [[-EncryptionLevel]
  <String>] [-MachineCertificateEKUFilter <String[]>] [-MachineCertificateIssuerFilter
  <X509Certificate2>] [-ServerList <CimInstance[]>] [-IdleDisconnectSeconds <UInt32>]
  [-DnsSuffix <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VpnConnection [-Name] <String> [[-ServerAddress] <String>] [[-SplitTunneling]
  <Boolean>] [[-RememberCredential] <Boolean>] [-PassThru] [-Force] [-ServerList <CimInstance[]>]
  [-IdleDisconnectSeconds <UInt32>] [-DnsSuffix <String>] [[-PlugInApplicationID]
  <String>] [-CustomConfiguration <XmlDocument>] [-ThirdPartyVpn] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllUserConnection Switch: ~
  -AsJob Switch: ~
  -AuthenticationMethod String[]:
    values:
    - Pap
    - Chap
    - MSChapv2
    - Eap
    - MachineCertificate
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CustomConfiguration XmlDocument: ~
  -DnsSuffix String: ~
  -EapConfigXmlStream XmlDocument: ~
  -EncryptionLevel String:
    values:
    - NoEncryption
    - Optional
    - Required
    - Maximum
    - Custom
  -Force Switch: ~
  -IdleDisconnectSeconds UInt32: ~
  -L2tpPsk String: ~
  -MachineCertificateEKUFilter String[]: ~
  -MachineCertificateIssuerFilter X509Certificate2: ~
  -Name,-ConnectionName String:
    required: true
  -PassThru Switch: ~
  -PlugInApplicationID String: ~
  -RememberCredential Boolean: ~
  -ServerAddress,-ServerName,-DefaultServer String: ~
  -ServerList CimInstance[]: ~
  -SplitTunneling Boolean: ~
  -ThirdPartyVpn Switch: ~
  -ThrottleLimit Int32: ~
  -TunnelType String:
    values:
    - Pptp
    - L2tp
    - Sstp
    - Ikev2
    - Automatic
  -UseWinlogonCredential Boolean: ~
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
