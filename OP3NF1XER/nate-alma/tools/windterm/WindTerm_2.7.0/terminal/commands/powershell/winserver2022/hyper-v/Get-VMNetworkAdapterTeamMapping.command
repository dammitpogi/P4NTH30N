description: ''
synopses:
- Get-VMNetworkAdapterTeamMapping [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String> [-Name <String>] [-Passthru] [<CommonParameters>]
- Get-VMNetworkAdapterTeamMapping [-ManagementOS] [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [-Name <String>] [-SwitchName <String>]
  [-Passthru] [<CommonParameters>]
- Get-VMNetworkAdapterTeamMapping [-VMNetworkAdapter] <VMNetworkAdapterBase> [-Passthru]
  [<CommonParameters>]
- Get-VMNetworkAdapterTeamMapping [-VM] <VirtualMachine> [-Name <String>] [-Passthru]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -ManagementOS Switch:
    required: true
  -Name,-VMNetworkAdapterName String: ~
  -Passthru Switch: ~
  -SwitchName String: ~
  -VM VirtualMachine:
    required: true
  -VMName String:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase:
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
