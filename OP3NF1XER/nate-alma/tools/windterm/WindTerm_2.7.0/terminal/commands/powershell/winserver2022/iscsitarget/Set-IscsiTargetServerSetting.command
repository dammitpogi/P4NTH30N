description: Sets the global settings or common configurations for an iSCSI target
  virtual disk
synopses:
- Set-IscsiTargetServerSetting [-IP] <String> [-Port <Int32>] [-Enable <Boolean>]
  [-PassThru] [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Set-IscsiTargetServerSetting -DisableRemoteManagement <Boolean> [-PassThru] [-ComputerName
  <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Credential PSCredential: ~
  -DisableRemoteManagement Boolean:
    required: true
  -Enable Boolean: ~
  -IP String:
    required: true
  -PassThru Switch: ~
  -Port Int32: ~
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
