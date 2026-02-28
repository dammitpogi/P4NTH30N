description: Modifies the boot configuration on the remote hardware device
synopses:
- Set-PcsvDeviceBootConfiguration [-TimeoutSec <UInt32>] [[-OneTimeBootSource] <String>]
  [[-PersistentBootSource] <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-PcsvDeviceBootConfiguration [-TargetAddress] <String> [-Credential] <PSCredential>
  [-ManagementProtocol] <ManagementProtocol> [[-Port] <UInt16>] [-Authentication <Authentication>]
  [-UseSSL] [-SkipCACheck] [-SkipCNCheck] [-SkipRevocationCheck] [-TimeoutSec <UInt32>]
  [[-OneTimeBootSource] <String>] [[-PersistentBootSource] <String[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-PcsvDeviceBootConfiguration -InputObject <CimInstance[]> [[-OneTimeBootSource]
  <String>] [[-PersistentBootSource] <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -Authentication Authentication:
    values:
    - Default
    - Basic
    - Digest
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential:
    required: true
  -InputObject CimInstance[]:
    required: true
  -ManagementProtocol,-MP ManagementProtocol:
    required: true
    values:
    - WSMan
    - IPMI
  -OneTimeBootSource,-OT,-NextBoot String: ~
  -PassThru Switch: ~
  -PersistentBootSource,-PT,-Persistent String[]: ~
  -Port UInt16: ~
  -SkipCACheck Switch: ~
  -SkipCNCheck Switch: ~
  -SkipRevocationCheck Switch: ~
  -TargetAddress,-CN,-ComputerName,-IpAddress String:
    required: true
  -ThrottleLimit Int32: ~
  -TimeoutSec UInt32: ~
  -UseSSL Switch: ~
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
