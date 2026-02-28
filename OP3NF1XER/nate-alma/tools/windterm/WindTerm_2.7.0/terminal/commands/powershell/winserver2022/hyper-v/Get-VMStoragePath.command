description: Gets the storage paths in a storage resource pool
synopses:
- Get-VMStoragePath [[-Path] <String[]>] [-ResourcePoolName] <String[]> [-ResourcePoolType]
  <VMResourcePoolType> [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Path String[]: ~
  -ResourcePoolName String[]:
    required: true
  -ResourcePoolType VMResourcePoolType:
    required: true
    values:
    - Memory
    - Processor
    - Ethernet
    - VHD
    - ISO
    - VFD
    - FibreChannelPort
    - FibreChannelConnection
    - PciExpress
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
