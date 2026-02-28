description: Modifies the configuration that is common to both DirectAccess (DA) and
  VPN such SSL certificate, Internal interface, and Internet interface
synopses:
- Set-RemoteAccess [-SslCertificate <X509Certificate2>] [-ComputerName <String>] [-InternetInterface
  <String>] [-InternalInterface <String>] [-Force] [-PassThru] [-CapacityKbps <UInt64>]
  [-UseHttp <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CapacityKbps UInt64: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InternalInterface String: ~
  -InternetInterface String: ~
  -PassThru Switch: ~
  -SslCertificate X509Certificate2: ~
  -ThrottleLimit Int32: ~
  -UseHttp Boolean: ~
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
