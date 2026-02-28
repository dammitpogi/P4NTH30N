description: Gets a connection between DFS Replication partners
synopses:
- Get-DfsrConnection [[-GroupName] <String[]>] [[-SourceComputerName] <String>] [[-DestinationComputerName]
  <String>] [[-DomainName] <String>] [<CommonParameters>]
options:
  -DestinationComputerName,-ReceivingMember,-RMem String: ~
  -DomainName String: ~
  -GroupName,-RG,-RgName String[]: ~
  -SourceComputerName,-SendingMember,-SMem String: ~
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
