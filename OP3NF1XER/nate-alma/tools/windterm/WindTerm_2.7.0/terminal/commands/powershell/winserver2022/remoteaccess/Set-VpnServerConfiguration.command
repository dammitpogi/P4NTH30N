description: Updates S2S server parameters
synopses:
- Set-VpnServerConfiguration [-TunnelType <TunnelType>] [-SstpPorts <UInt32>] [-GrePorts
  <UInt32>] [-IdleDisconnectSeconds <UInt32>] [-SALifeTimeSeconds <UInt32>] [-MMSALifeTimeSeconds
  <UInt32>] [-SADataSizeForRenegotiationKilobytes <UInt32>] [-Ikev2Ports <UInt32>]
  [-L2tpPorts <UInt32>] [-PassThru] [-EncryptionType <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VpnServerConfiguration [-TunnelType <TunnelType>] [-PassThru] [-RevertToDefault]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-VpnServerConfiguration [-TunnelType <TunnelType>] [-SstpPorts <UInt32>] [-GrePorts
  <UInt32>] [-IdleDisconnectSeconds <UInt32>] [-SALifeTimeSeconds <UInt32>] [-MMSALifeTimeSeconds
  <UInt32>] [-SADataSizeForRenegotiationKilobytes <UInt32>] [-Ikev2Ports <UInt32>]
  [-L2tpPorts <UInt32>] [-PassThru] [-CustomPolicy] [-EncryptionMethod <EncryptionMethod>]
  [-IntegrityCheckMethod <IntegrityCheckMethod>] [-CipherTransformConstants <CipherTransformConstants>]
  [-PfsGroup <PfsGroup>] [-AuthenticationTransformConstants <AuthenticationTransformConstants>]
  [-DHGroup <DHGroup>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AuthenticationTransformConstants,-FirstTransformType AuthenticationTransformConstants:
    values:
    - MD596
    - SHA196
    - SHA256128
    - GCMAES128
    - GCMAES192
    - GCMAES256
    - None
  -CimSession,-Session CimSession[]: ~
  -CipherTransformConstants,-FirstCipherAlgorithm,-OtherCipherAlgorithm CipherTransformConstants:
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
  -CustomPolicy Switch:
    required: true
  -DHGroup DHGroup:
    values:
    - None
    - Group1
    - Group2
    - Group14
    - ECP256
    - ECP384
    - Group24
  -EncryptionMethod,-Encryption EncryptionMethod:
    values:
    - DES
    - DES3
    - AES128
    - AES192
    - AES256
    - GCMAES128
    - GCMAES256
  -EncryptionType String:
    values:
    - NoEncryption
    - RequireEncryption
    - OptionalEncryption
    - MaximumEncryption
  -GrePorts UInt32: ~
  -IdleDisconnectSeconds,-IdleDurationSeconds UInt32: ~
  -Ikev2Ports UInt32: ~
  -IntegrityCheckMethod,-FirstIntegrityAlgorithm,-OtherHashAlgorithm IntegrityCheckMethod:
    values:
    - MD5
    - SHA1
    - SHA256
    - SHA384
  -L2tpPorts UInt32: ~
  -MMSALifeTimeSeconds UInt32: ~
  -PassThru Switch: ~
  -PfsGroup,-PfsGroupId PfsGroup:
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
  -SADataSizeForRenegotiationKilobytes,-LifeTimeKiloBytes UInt32: ~
  -SALifeTimeSeconds,-LifeTimeSeconds,-QMSALifeTimeSeconds UInt32: ~
  -SstpPorts UInt32: ~
  -ThrottleLimit Int32: ~
  -TunnelType TunnelType:
    values:
    - IKEV2
    - L2TP
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
