description: Modifies the Teredo configuration of a computer or a Group Policy object
  (GPO)
synopses:
- Set-NetTeredoConfiguration [-IPInterface <CimInstance>] [-PolicyStore <String>]
  [-GPOSession <String>] [[-Type] <Type>] [[-ServerName] <String>] [[-RefreshIntervalSeconds]
  <UInt32>] [[-ClientPort] <UInt32>] [[-ServerVirtualIP] <String>] [[-DefaultQualified]
  <Boolean>] [[-ServerShunt] <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetTeredoConfiguration -InputObject <CimInstance[]> [[-Type] <Type>] [[-ServerName]
  <String>] [[-RefreshIntervalSeconds] <UInt32>] [[-ClientPort] <UInt32>] [[-ServerVirtualIP]
  <String>] [[-DefaultQualified] <Boolean>] [[-ServerShunt] <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientPort UInt32: ~
  -Confirm,-cf Switch: ~
  -DefaultQualified Boolean: ~
  -GPOSession String: ~
  -IPInterface CimInstance: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
  -RefreshIntervalSeconds,-RefreshInterval UInt32: ~
  -ServerName String: ~
  -ServerShunt Boolean: ~
  -ServerVirtualIP String: ~
  -ThrottleLimit Int32: ~
  -Type Type:
    values:
    - Default
    - Relay
    - Client
    - Server
    - Disabled
    - Automatic
    - Enterpriseclient
    - Natawareclient
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
