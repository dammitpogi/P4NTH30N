description: Enables shared configuration
synopses:
- Enable-IISSharedConfig [-PhysicalPath] <String> [[-UserName] <String>] [[-Password]
  <SecureString>] [[-KeyEncryptionPassword] <SecureString>] [-DontCopyRemoteKeys]
  [-Force] [<CommonParameters>]
options:
  -DontCopyRemoteKeys Switch: ~
  -Force Switch: ~
  -KeyEncryptionPassword SecureString: ~
  -Password SecureString: ~
  -PhysicalPath String:
    required: true
  -UserName String: ~
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
