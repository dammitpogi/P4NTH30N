description: Automates the provisioning of IPAM server
synopses:
- Invoke-IpamServerProvisioning [-WidSchemaPath <String>] [-ProvisioningMethod <ProvisioningMethod>]
  [-GpoPrefix <String>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Invoke-IpamServerProvisioning [-ProvisioningMethod <ProvisioningMethod>] [-GpoPrefix
  <String>] [-Force] [-DatabaseServer] <String> [-DatabaseName] <String> [-DatabasePort]
  <UInt16> [-DatabaseAuthType <AuthType>] [-DatabaseCredential <PSCredential>] [-UseExistingSchema]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DatabaseAuthType AuthType:
    values:
    - Windows
    - SQL
  -DatabaseCredential PSCredential: ~
  -DatabaseName String:
    required: true
  -DatabasePort UInt16:
    required: true
  -DatabaseServer String:
    required: true
  -Force Switch: ~
  -GpoPrefix String: ~
  -ProvisioningMethod ProvisioningMethod:
    values:
    - Automatic
    - Manual
  -ThrottleLimit Int32: ~
  -UseExistingSchema Switch: ~
  -WhatIf,-wi Switch: ~
  -WidSchemaPath String: ~
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
