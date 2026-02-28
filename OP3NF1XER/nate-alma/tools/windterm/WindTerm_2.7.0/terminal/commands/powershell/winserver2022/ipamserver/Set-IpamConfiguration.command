description: Modifies the configuration for the computer that runs the IPAM server
synopses:
- Set-IpamConfiguration [-Port] <UInt16> [-Force] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamConfiguration [-Force] [-PassThru] [-UpdateTables] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamConfiguration [-Force] [-PassThru] -HmacKey <SecureString> [-UpdateTables]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-IpamConfiguration [-Force] [-PassThru] [-RefreshHmacKey] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamConfiguration [-Force] [-PassThru] [-ProvisioningMethod] <ProvisioningMethod>
  [[-GpoPrefix] <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -GpoPrefix String: ~
  -HmacKey SecureString:
    required: true
  -PassThru Switch: ~
  -Port UInt16:
    required: true
  -ProvisioningMethod ProvisioningMethod:
    required: true
    values:
    - Automatic
    - Manual
  -RefreshHmacKey Switch:
    required: true
  -ThrottleLimit Int32: ~
  -UpdateTables Switch:
    required: true
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
