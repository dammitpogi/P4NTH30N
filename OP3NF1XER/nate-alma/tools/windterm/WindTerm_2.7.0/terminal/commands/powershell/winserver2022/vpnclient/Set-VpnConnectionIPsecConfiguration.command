description: Sets the IPsec parameters of a VPN connection
synopses:
- Set-VpnConnectionIPsecConfiguration [-ConnectionName] <String> [-Force] [-AllUserConnection]
  [-RevertToDefault] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VpnConnectionIPsecConfiguration [-ConnectionName] <String> [-AuthenticationTransformConstants]
  <AuthenticationTransformConstants> [-CipherTransformConstants] <CipherTransformConstants>
  [-EncryptionMethod] <EncryptionMethod> [-IntegrityCheckMethod] <IntegrityCheckMethod>
  [-PfsGroup] <PfsGroup> [-DHGroup] <DHGroup> [-PassThru] [-Force] [-AllUserConnection]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AllUserConnection Switch: ~
  -AsJob Switch: ~
  -AuthenticationTransformConstants AuthenticationTransformConstants:
    required: true
    values:
    - MD596
    - SHA196
    - SHA256128
    - GCMAES128
    - GCMAES192
    - GCMAES256
    - None
  -CimSession,-Session CimSession[]: ~
  -CipherTransformConstants CipherTransformConstants:
    required: true
    values:
    - DES
    - DES3
    - AES128
    - AES192
    - AES256
    - GCMAES128
    - GCMAES192
    - GCMAES256
    - None
  -Confirm,-cf Switch: ~
  -ConnectionName,-Name String:
    required: true
  -DHGroup DHGroup:
    required: true
    values:
    - None
    - Group1
    - Group2
    - Group14
    - ECP256
    - ECP384
    - Group24
  -EncryptionMethod EncryptionMethod:
    required: true
    values:
    - DES
    - DES3
    - AES128
    - AES192
    - AES256
    - GCMAES128
    - GCMAES256
  -Force Switch: ~
  -IntegrityCheckMethod IntegrityCheckMethod:
    required: true
    values:
    - MD5
    - SHA1
    - SHA256
    - SHA384
  -PassThru Switch: ~
  -PfsGroup PfsGroup:
    required: true
    values:
    - None
    - PFS1
    - PFS2
    - PFS2048
    - ECP256
    - ECP384
    - PFSMM
    - PFS24
  -RevertToDefault Switch:
    required: true
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
