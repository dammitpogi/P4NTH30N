description: Starts recovery of a Hyper-V Server 2016 virtual machine
synopses:
- Start-WBHyperVRecovery [-BackupSet] <WBBackupSet> [-VMInBackup] <WBVirtualMachine[]>
  [[-TargetPath] <String>] [-NoRollForward] [-Async] [-Force] [-UseAlternateLocation]
  [-RecreatePath] [<CommonParameters>]
options:
  -Async Switch: ~
  -BackupSet WBBackupSet:
    required: true
  -Force Switch: ~
  -NoRollForward Switch: ~
  -RecreatePath Switch: ~
  -TargetPath String: ~
  -UseAlternateLocation Switch: ~
  -VMInBackup WBVirtualMachine[]:
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
