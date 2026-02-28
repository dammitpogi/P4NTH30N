description: Sets the properties specific to the DirectAccess (DA) server
synopses:
- Set-DAServer [-ComputerName <String>] [-PassThru] [-Force] [-InternalIPv6Prefix
  <String[]>] [-ClientIPv6Prefix <String>] [-TeredoState <String>] [-ConnectToAddress
  <String>] [-UserAuthentication <String>] [-IPsecRootCertificate <X509Certificate2>]
  [-IntermediateRootCertificate] [-EntrypointName <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DAServer [-ComputerName <String>] [-PassThru] [-Force] [-InternalIPv6Prefix
  <String[]>] [-ClientIPv6Prefix <String>] [-DisableComputerCertAuthentication] [-TeredoState
  <String>] [-ConnectToAddress <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DAServer [-ComputerName <String>] -DAInstallType <String> [-PassThru] [-Force]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientIPv6Prefix String: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -ConnectToAddress String: ~
  -DAInstallType String:
    required: true
    values:
    - FullInstall
    - ManageOut
  -DisableComputerCertAuthentication Switch:
    required: true
  -EntrypointName String: ~
  -Force Switch: ~
  -IPsecRootCertificate X509Certificate2: ~
  -IntermediateRootCertificate Switch: ~
  -InternalIPv6Prefix String[]: ~
  -PassThru Switch: ~
  -TeredoState String:
    values:
    - Enabled
    - Disabled
  -ThrottleLimit Int32: ~
  -UserAuthentication String:
    values:
    - TwoFactor
    - UserPasswd
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
