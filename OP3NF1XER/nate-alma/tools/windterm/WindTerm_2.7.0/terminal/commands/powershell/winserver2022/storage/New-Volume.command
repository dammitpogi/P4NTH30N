description: Creates a volume with the specified file system
synopses:
- New-Volume [-StoragePool] <CimInstance> -FriendlyName <String> [-FileSystem <FileSystemType>]
  [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize <UInt32>] [-Size
  <UInt64>] [-ResiliencySettingName <String>] [-ProvisioningType <ProvisioningType>]
  [-MediaType <MediaType>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfColumns <UInt16>]
  [-NumberOfGroups <UInt16>] [-StorageTiers <CimInstance[]>] [-StorageTierFriendlyNames
  <String[]>] [-StorageTierSizes <UInt64[]>] [-WriteCacheSize <UInt64>] [-ReadCacheSize
  <UInt64>] [-UseMaximumSize] [-CimSession <CimSession>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-Volume -StoragePoolFriendlyName <String> -FriendlyName <String> [-FileSystem
  <FileSystemType>] [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize
  <UInt32>] [-Size <UInt64>] [-ResiliencySettingName <String>] [-ProvisioningType
  <ProvisioningType>] [-MediaType <MediaType>] [-PhysicalDiskRedundancy <UInt16>]
  [-NumberOfColumns <UInt16>] [-NumberOfGroups <UInt16>] [-StorageTiers <CimInstance[]>]
  [-StorageTierFriendlyNames <String[]>] [-StorageTierSizes <UInt64[]>] [-WriteCacheSize
  <UInt64>] [-ReadCacheSize <UInt64>] [-UseMaximumSize] [-CimSession <CimSession>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-Volume -StoragePoolName <String> -FriendlyName <String> [-FileSystem <FileSystemType>]
  [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize <UInt32>] [-Size
  <UInt64>] [-ResiliencySettingName <String>] [-ProvisioningType <ProvisioningType>]
  [-MediaType <MediaType>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfColumns <UInt16>]
  [-NumberOfGroups <UInt16>] [-StorageTiers <CimInstance[]>] [-StorageTierFriendlyNames
  <String[]>] [-StorageTierSizes <UInt64[]>] [-WriteCacheSize <UInt64>] [-ReadCacheSize
  <UInt64>] [-UseMaximumSize] [-CimSession <CimSession>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-Volume -StoragePoolUniqueId <String> -FriendlyName <String> [-FileSystem <FileSystemType>]
  [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize <UInt32>] [-Size
  <UInt64>] [-ResiliencySettingName <String>] [-ProvisioningType <ProvisioningType>]
  [-MediaType <MediaType>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfColumns <UInt16>]
  [-NumberOfGroups <UInt16>] [-StorageTiers <CimInstance[]>] [-StorageTierFriendlyNames
  <String[]>] [-StorageTierSizes <UInt64[]>] [-WriteCacheSize <UInt64>] [-ReadCacheSize
  <UInt64>] [-UseMaximumSize] [-CimSession <CimSession>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-Volume [-Disk] <CimInstance> -FriendlyName <String> [-FileSystem <FileSystemType>]
  [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize <UInt32>] [-CimSession
  <CimSession>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-Volume [-DiskNumber] <UInt32> -FriendlyName <String> [-FileSystem <FileSystemType>]
  [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize <UInt32>] [-CimSession
  <CimSession>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-Volume -DiskPath <String> -FriendlyName <String> [-FileSystem <FileSystemType>]
  [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize <UInt32>] [-CimSession
  <CimSession>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-Volume -DiskUniqueId <String> -FriendlyName <String> [-FileSystem <FileSystemType>]
  [-AccessPath <String>] [-DriveLetter <Char>] [-AllocationUnitSize <UInt32>] [-CimSession
  <CimSession>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AccessPath String: ~
  -AllocationUnitSize UInt32: ~
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -Disk CimInstance:
    required: true
  -DiskNumber UInt32:
    required: true
  -DiskPath String:
    required: true
  -DiskUniqueId String:
    required: true
  -DriveLetter Char: ~
  -FileSystem FileSystemType:
    values:
    - NTFS
    - ReFS
    - CSVFS_NTFS
    - CSVFS_ReFS
  -FriendlyName String:
    required: true
  -MediaType MediaType:
    values:
    - HDD
    - SSD
    - SCM
  -NumberOfColumns UInt16: ~
  -NumberOfGroups UInt16: ~
  -PhysicalDiskRedundancy UInt16: ~
  -ProvisioningType ProvisioningType:
    values:
    - Unknown
    - Thin
    - Fixed
  -ReadCacheSize UInt64: ~
  -ResiliencySettingName String: ~
  -Size UInt64: ~
  -StoragePool CimInstance:
    required: true
  -StoragePoolFriendlyName String:
    required: true
  -StoragePoolName String:
    required: true
  -StoragePoolUniqueId String:
    required: true
  -StorageTierFriendlyNames String[]: ~
  -StorageTierSizes UInt64[]: ~
  -StorageTiers CimInstance[]: ~
  -ThrottleLimit Int32: ~
  -UseMaximumSize Switch: ~
  -WriteCacheSize UInt64: ~
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
