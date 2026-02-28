description: Backs up the CA database and private key information
synopses:
- Backup-CARoleService [-Path] <String> [-Force] [-KeyOnly] [-Password <SecureString>]
  [<CommonParameters>]
- Backup-CARoleService [-Path] <String> [-Force] [-DatabaseOnly] [-Incremental] [-KeepLog]
  [<CommonParameters>]
- Backup-CARoleService [-Path] <String> [-Force] [-Password <SecureString>] [-Incremental]
  [-KeepLog] [<CommonParameters>]
options:
  -DatabaseOnly Switch:
    required: true
  -Force Switch: ~
  -Incremental Switch: ~
  -KeepLog Switch: ~
  -KeyOnly Switch:
    required: true
  -Password SecureString: ~
  -Path String:
    required: true
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
