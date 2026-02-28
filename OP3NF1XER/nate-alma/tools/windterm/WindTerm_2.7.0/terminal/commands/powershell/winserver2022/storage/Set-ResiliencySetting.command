description: Modifies the properties of the specified resiliency setting name
synopses:
- Set-ResiliencySetting -Name <String[]> -StoragePool <CimInstance> [-NumberOfDataCopiesDefault
  <UInt16>] [-PhysicalDiskRedundancyDefault <UInt16>] [-NumberOfColumnsDefault <UInt16>]
  [-AutoNumberOfColumns] [-InterleaveDefault <UInt64>] [-NumberOfGroupsDefault <UInt16>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Set-ResiliencySetting -UniqueId <String[]> [-NumberOfDataCopiesDefault <UInt16>]
  [-PhysicalDiskRedundancyDefault <UInt16>] [-NumberOfColumnsDefault <UInt16>] [-AutoNumberOfColumns]
  [-InterleaveDefault <UInt64>] [-NumberOfGroupsDefault <UInt16>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Set-ResiliencySetting -InputObject <CimInstance[]> [-NumberOfDataCopiesDefault <UInt16>]
  [-PhysicalDiskRedundancyDefault <UInt16>] [-NumberOfColumnsDefault <UInt16>] [-AutoNumberOfColumns]
  [-InterleaveDefault <UInt64>] [-NumberOfGroupsDefault <UInt16>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutoNumberOfColumns Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InputObject CimInstance[]:
    required: true
  -InterleaveDefault UInt64: ~
  -Name String[]:
    required: true
  -NumberOfColumnsDefault UInt16: ~
  -NumberOfDataCopiesDefault UInt16: ~
  -NumberOfGroupsDefault UInt16: ~
  -PassThru Switch: ~
  -PhysicalDiskRedundancyDefault UInt16: ~
  -StoragePool CimInstance:
    required: true
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]:
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
