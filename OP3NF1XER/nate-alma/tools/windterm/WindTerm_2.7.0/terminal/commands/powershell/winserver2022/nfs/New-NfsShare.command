description: Creates an NFS file share
synopses:
- New-NfsShare [-Name] <String> [-Path] <String> [[-NetworkName] <String>] [[-Authentication]
  <String[]>] [[-AnonymousUid] <Int32>] [[-AnonymousGid] <Int32>] [[-LanguageEncoding]
  <String>] [[-EnableAnonymousAccess] <Boolean>] [[-EnableUnmappedAccess] <Boolean>]
  [[-AllowRootAccess] <Boolean>] [[-Permission] <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowRootAccess Boolean: ~
  -AnonymousGid,-AnonGid Int32: ~
  -AnonymousUid,-AnonUid Int32: ~
  -AsJob Switch: ~
  -Authentication,-af,-auth String[]:
    values:
    - sys
    - krb5
    - krb5i
    - krb5p
    - all
    - default
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EnableAnonymousAccess,-anon,-AnonymousAccess Boolean: ~
  -EnableUnmappedAccess,-unmapped,-UnmappedAccess Boolean: ~
  -LanguageEncoding,-lang,-encoding String:
    values:
    - euc-jp
    - euc-tw
    - euc-kr
    - shift-jis
    - big5
    - ksc5601
    - gb2312-80
    - ansi
  -Name,-ShareName String:
    required: true
  -NetworkName,-netname String: ~
  -Path,-SharePath String:
    required: true
  -Permission,-access String:
    values:
    - no-access
    - readonly
    - readwrite
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
