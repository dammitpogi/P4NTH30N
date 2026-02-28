description: Gets the status of the virtual machines on the non-uniform memory access
  (NUMA) nodes of a virtual machine host or hosts
synopses:
- Get-VMHostNumaNodeStatus [[-ComputerName] <String[]>] [[-Credential] <PSCredential[]>]
  [-Id <Int32>] [<CommonParameters>]
- Get-VMHostNumaNodeStatus [-CimSession] <CimSession[]> [-Id <Int32>] [<CommonParameters>]
options:
  -CimSession CimSession[]:
    required: true
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Id Int32: ~
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
