description: Takes a Disk object or unique disk identifiers and a set of attributes,
  and updates the physical disk on the system
synopses:
- Set-Disk [-Number] <UInt32> [-IsReadOnly <Boolean>] [-Signature <UInt32>] [-Guid
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk -InputObject <CimInstance[]> [-IsReadOnly <Boolean>] [-Signature <UInt32>]
  [-Guid <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Set-Disk -InputObject <CimInstance[]> [-IsOffline <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk -InputObject <CimInstance[]> [-PartitionStyle <PartitionStyle>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk [-PartitionStyle <PartitionStyle>] [-Number] <UInt32> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk [-PartitionStyle <PartitionStyle>] -Path <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk [-PartitionStyle <PartitionStyle>] -UniqueId <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk -UniqueId <String> [-IsReadOnly <Boolean>] [-Signature <UInt32>] [-Guid
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk -UniqueId <String> [-IsOffline <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk -Path <String> [-IsReadOnly <Boolean>] [-Signature <UInt32>] [-Guid <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk -Path <String> [-IsOffline <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-Disk [-Number] <UInt32> [-IsOffline <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Guid String: ~
  -InputObject CimInstance[]:
    required: true
  -IsOffline Boolean: ~
  -IsReadOnly Boolean: ~
  -Number UInt32:
    required: true
  -PartitionStyle PartitionStyle:
    values:
    - Unknown
    - MBR
    - GPT
  -Path String:
    required: true
  -Signature UInt32: ~
  -ThrottleLimit Int32: ~
  -UniqueId String:
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
