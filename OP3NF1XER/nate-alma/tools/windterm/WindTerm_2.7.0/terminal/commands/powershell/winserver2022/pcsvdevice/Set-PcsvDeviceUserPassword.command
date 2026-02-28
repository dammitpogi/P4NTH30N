description: Changes the password of a user on a PCSV device
synopses:
- Set-PcsvDeviceUserPassword [-TimeoutSec <UInt32>] [-CurrentCredential] <PSCredential>
  [-NewPassword] <SecureString> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-PcsvDeviceUserPassword [-TargetAddress] <String> [-Credential] <PSCredential>
  [-ManagementProtocol] <ManagementProtocol> [[-Port] <UInt16>] [-Authentication <Authentication>]
  [-UseSSL] [-SkipCACheck] [-SkipCNCheck] [-SkipRevocationCheck] [-TimeoutSec <UInt32>]
  [-CurrentCredential] <PSCredential> [-NewPassword] <SecureString> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-PcsvDeviceUserPassword -InputObject <CimInstance[]> [-CurrentCredential] <PSCredential>
  [-NewPassword] <SecureString> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -CurrentCredential PSCredential:
    required: true
  -InputObject CimInstance[]:
    required: true
  -ManagementProtocol,-MP ManagementProtocol:
    required: true
    values:
    - WSMan
    - IPMI
  -NewPassword SecureString:
    required: true
  -PassThru Switch: ~
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
