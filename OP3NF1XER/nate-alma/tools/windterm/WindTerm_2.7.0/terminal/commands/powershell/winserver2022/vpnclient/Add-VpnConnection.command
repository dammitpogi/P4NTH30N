description: Adds a VPN connection to the Connection Manager phone book
synopses:
- Add-VpnConnection [-Name] <String> [-ServerAddress] <String> [-RememberCredential]
  [-SplitTunneling] [-Force] [-PassThru] [-ServerList <CimInstance[]>] [-DnsSuffix
  <String>] [-IdleDisconnectSeconds <UInt32>] [-PlugInApplicationID] <String> -CustomConfiguration
  <XmlDocument> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VpnConnection [-Name] <String> [-ServerAddress] <String> [[-TunnelType] <String>]
  [-AllUserConnection] [-RememberCredential] [-SplitTunneling] [-Force] [-PassThru]
  [[-L2tpPsk] <String>] [-UseWinlogonCredential] [-ServerList <CimInstance[]>] [-DnsSuffix
  <String>] [-IdleDisconnectSeconds <UInt32>] [[-EapConfigXmlStream] <XmlDocument>]
  [[-AuthenticationMethod] <String[]>] [[-EncryptionLevel] <String>] [-MachineCertificateIssuerFilter
  <X509Certificate2>] [-MachineCertificateEKUFilter <String[]>] [-CimSession <CimSession[]>]
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
  -CustomConfiguration XmlDocument:
    required: true
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
  -PlugInApplicationID String:
    required: true
  -RememberCredential Switch: ~
  -ServerAddress,-ServerName,-DefaultServer String:
    required: true
  -ServerList CimInstance[]: ~
  -SplitTunneling Switch: ~
  -ThrottleLimit Int32: ~
  -TunnelType String:
    values:
    - Pptp
    - L2tp
    - Sstp
    - Ikev2
    - Automatic
  -UseWinlogonCredential Switch: ~
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
