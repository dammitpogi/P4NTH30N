description: Resets the Teredo configuration elements in a Group Policy Object (GPO)
synopses:
- Reset-NetTeredoConfiguration [-IPInterface <CimInstance>] [-PolicyStore <String>]
  [-GPOSession <String>] [-Type] [-ServerName] [-RefreshIntervalSeconds] [-ClientPort]
  [-ServerVirtualIP] [-DefaultQualified] [-ServerShunt] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Reset-NetTeredoConfiguration -InputObject <CimInstance[]> [-Type] [-ServerName]
  [-RefreshIntervalSeconds] [-ClientPort] [-ServerVirtualIP] [-DefaultQualified] [-ServerShunt]
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientPort Switch: ~
  -Confirm,-cf Switch: ~
  -DefaultQualified Switch: ~
  -GPOSession String: ~
  -IPInterface CimInstance: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
  -RefreshIntervalSeconds,-RefreshInterval Switch: ~
  -ServerName Switch: ~
  -ServerShunt Switch: ~
  -ServerVirtualIP Switch: ~
  -ThrottleLimit Int32: ~
  -Type Switch: ~
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
