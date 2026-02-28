description: Modifies settings of the Sync Share
synopses:
- Set-SyncServerSetting [-InputObject <CimInstance[]>] [-Description <String>] [-AdministratorEmail
  <String>] [-ADFSUrl <String>] [-SuspendedUser <String[]>] [-MinimumChangeDetectionMins
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADFSUrl,-ADFSAuthenticationUrl String: ~
  -AdministratorEmail String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -InputObject CimInstance[]: ~
  -MinimumChangeDetectionMins UInt32: ~
  -PassThru Switch: ~
  -SuspendedUser,-DeniedAccount,-BlockedUser String[]: ~
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
