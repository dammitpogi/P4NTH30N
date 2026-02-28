description: Restores a configuration from a backup file
synopses:
- Restore-SbecBackupConfig -Name <String> [-OldTimestamp <UInt64>] [-Continue] [-ComputerName
  <String[]>] [-CimSession <CimSession[]>] [<CommonParameters>]
- Restore-SbecBackupConfig -At <Object> [-OldTimestamp <UInt64>] [-Continue] [-ComputerName
  <String[]>] [-CimSession <CimSession[]>] [<CommonParameters>]
- Restore-SbecBackupConfig -AtTimestamp <UInt64> [-OldTimestamp <UInt64>] [-Continue]
  [-ComputerName <String[]>] [-CimSession <CimSession[]>] [<CommonParameters>]
options:
  -At Object:
    required: true
  -AtTimestamp UInt64:
    required: true
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Continue Switch: ~
  -Name String:
    required: true
  -OldTimestamp UInt64: ~
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
