description: Gets virtual switches from one or more virtual Hyper-V hosts
synopses:
- Get-VMSwitch [[-Name] <String>] [[-ResourcePoolName] <String[]>] [-SwitchType <VMSwitchType[]>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [<CommonParameters>]
- Get-VMSwitch [[-Id] <Guid[]>] [[-ResourcePoolName] <String[]>] [-SwitchType <VMSwitchType[]>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Id,-SwitchId Guid[]: ~
  -Name,-SwitchName String: ~
  -ResourcePoolName String[]: ~
  -SwitchType VMSwitchType[]:
    values:
    - Private
    - Internal
    - External
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
