description: 'Creates a virtual machine group.  With Hyper-V, there are two types
  of VMGroups: a VMCollectionType and a ManagementCollectionType.  A VMCollectionType
  VMGroup contains VMs while the ManagementCollectionType VMGroup contains VMCollectionType
  VMGroups. For example, you could have two VMCollectionType VMGroups VMG1 (containing
  VMs VM1 and VM2) and a second VMG2 (containing VMs VM3 and VM4).  You could then
  create a ManagementCollectionType VMGroup VM-All containing the two VMCollectionType
  VMGroups. You use the [Add-VMGroupMember](./Add-VMGroupMember.md) cmdlet to add
  VMs to VMCollectionType VMGroups and to add VMCollectionType groups to ManagementCollectionType
  VMGroups'
synopses:
- powershell New-VMGroup [-Name] <String> [-GroupType] <GroupType> [[-Id] <Guid>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -GroupType GroupType:
    required: true
    values:
    - VMCollectionType
    - ManagementCollectionType
  -Id Guid: ~
  -Name String:
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
