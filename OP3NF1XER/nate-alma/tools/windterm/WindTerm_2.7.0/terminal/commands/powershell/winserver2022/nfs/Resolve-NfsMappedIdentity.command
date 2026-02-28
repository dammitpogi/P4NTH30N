description: Resolves the mapping of a Windows user account or group account to a
  UNIX identifier
synopses:
- Resolve-NfsMappedIdentity [[-AccountType] <WindowsAccountType>] [-Id] <UInt32> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Resolve-NfsMappedIdentity [-AccountName] <String> [[-AccountType] <WindowsAccountType>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AccountName String:
    required: true
  -AccountType,-type WindowsAccountType:
    values:
    - User
    - Group
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Id,-uid,-gid,-Identifier UInt32:
    required: true
  -ThrottleLimit Int32: ~
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
