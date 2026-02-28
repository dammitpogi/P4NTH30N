description: Modifies the settings for the specified iSCSI virtual disk
synopses:
- Set-IscsiVirtualDisk [-Path] <String> [-Description <String>] [-PassThru] [-Enable
  <Boolean>] [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Set-IscsiVirtualDisk -InputObject <IscsiVirtualDisk> [-Description <String>] [-PassThru]
  [-Enable <Boolean>] [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Enable Boolean: ~
  -InputObject IscsiVirtualDisk:
    required: true
  -PassThru Switch: ~
  -Path,-DevicePath String:
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
