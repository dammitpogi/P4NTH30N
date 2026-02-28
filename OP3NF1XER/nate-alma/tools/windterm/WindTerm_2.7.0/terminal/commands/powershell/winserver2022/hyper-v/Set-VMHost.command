description: Configures a Hyper-V host
synopses:
- Set-VMHost [[-ComputerName] <String[]>] [[-Credential] <PSCredential[]>] [-MaximumStorageMigrations
  <UInt32>] [-MaximumVirtualMachineMigrations <UInt32>] [-VirtualMachineMigrationAuthenticationType
  <MigrationAuthenticationType>] [-UseAnyNetworkForMigration <Boolean>] [-VirtualMachineMigrationPerformanceOption
  <VMMigrationPerformance>] [-ResourceMeteringSaveInterval <TimeSpan>] [-VirtualHardDiskPath
  <String>] [-VirtualMachinePath <String>] [-MacAddressMaximum <String>] [-MacAddressMinimum
  <String>] [-FibreChannelWwnn <String>] [-FibreChannelWwpnMaximum <String>] [-FibreChannelWwpnMinimum
  <String>] [-NumaSpanningEnabled <Boolean>] [-EnableEnhancedSessionMode <Boolean>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMHost [-CimSession] <CimSession[]> [-MaximumStorageMigrations <UInt32>] [-MaximumVirtualMachineMigrations
  <UInt32>] [-VirtualMachineMigrationAuthenticationType <MigrationAuthenticationType>]
  [-UseAnyNetworkForMigration <Boolean>] [-VirtualMachineMigrationPerformanceOption
  <VMMigrationPerformance>] [-ResourceMeteringSaveInterval <TimeSpan>] [-VirtualHardDiskPath
  <String>] [-VirtualMachinePath <String>] [-MacAddressMaximum <String>] [-MacAddressMinimum
  <String>] [-FibreChannelWwnn <String>] [-FibreChannelWwpnMaximum <String>] [-FibreChannelWwpnMinimum
  <String>] [-NumaSpanningEnabled <Boolean>] [-EnableEnhancedSessionMode <Boolean>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]:
    required: true
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -EnableEnhancedSessionMode Boolean: ~
  -FibreChannelWwnn String: ~
  -FibreChannelWwpnMaximum String: ~
  -FibreChannelWwpnMinimum String: ~
  -MacAddressMaximum String: ~
  -MacAddressMinimum String: ~
  -MaximumStorageMigrations UInt32: ~
  -MaximumVirtualMachineMigrations UInt32: ~
  -NumaSpanningEnabled Boolean: ~
  -Passthru Switch: ~
  -ResourceMeteringSaveInterval TimeSpan: ~
  -UseAnyNetworkForMigration Boolean: ~
  -VirtualHardDiskPath String: ~
  -VirtualMachineMigrationAuthenticationType MigrationAuthenticationType:
    values:
    - CredSSP
    - Kerberos
  -VirtualMachineMigrationPerformanceOption VMMigrationPerformance:
    values:
    - TCPIP
    - Compression
    - SMB
  -VirtualMachinePath String: ~
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
