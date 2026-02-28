description: Sets the configuration of Microsoft Group KdsSvc
synopses:
- Set-KdsConfiguration [-LocalTestOnly] [-SecretAgreementPublicKeyLength <Int32>]
  [-SecretAgreementPrivateKeyLength <Int32>] [-SecretAgreementParameters <Byte[]>]
  [-SecretAgreementAlgorithm <String>] [-KdfParameters <Byte[]>] [-KdfAlgorithm <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-KdsConfiguration [-LocalTestOnly] [-RevertToDefault] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-KdsConfiguration [-LocalTestOnly] [-InputObject] <KdsServerConfiguration> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -InputObject KdsServerConfiguration:
    required: true
  -KdfAlgorithm String: ~
  -KdfParameters Byte[]: ~
  -LocalTestOnly Switch: ~
  -RevertToDefault Switch:
    required: true
  -SecretAgreementAlgorithm String: ~
  -SecretAgreementParameters Byte[]: ~
  -SecretAgreementPrivateKeyLength Int32: ~
  -SecretAgreementPublicKeyLength Int32: ~
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
