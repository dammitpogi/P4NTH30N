description: Gets information that can uniquely identify a server
synopses:
- Get-UalSystemId [-PhysicalProcessorCount <UInt32[]>] [-CoresPerPhysicalProcessor
  <UInt32[]>] [-LogicalProcessorsPerPhysicalProcessor <UInt32[]>] [-OSMajor <UInt32[]>]
  [-OSMinor <UInt32[]>] [-OSBuildNumber <UInt32[]>] [-OSPlatformId <UInt32[]>] [-ServicePackMajor
  <UInt32[]>] [-ServicePackMinor <UInt32[]>] [-OSSuiteMask <UInt32[]>] [-OSProductType
  <UInt32[]>] [-OSSerialNumber <String[]>] [-OSCountryCode <String[]>] [-OSCurrentTimeZone
  <Int16[]>] [-OSDaylightInEffect <Boolean[]>] [-OSLastBootUpTime <DateTime[]>] [-MaximumMemory
  <UInt64[]>] [-SystemSMBIOSUUID <String[]>] [-SystemSerialNumber <String[]>] [-SystemDNSHostName
  <String[]>] [-SystemDomainName <String[]>] [-CreationTime <DateTime[]>] [-SystemManufacturer
  <String[]>] [-SystemProductName <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -CoresPerPhysicalProcessor UInt32[]: ~
  -CreationTime DateTime[]: ~
  -LogicalProcessorsPerPhysicalProcessor UInt32[]: ~
  -MaximumMemory UInt64[]: ~
  -OSBuildNumber UInt32[]: ~
  -OSCountryCode String[]: ~
  -OSCurrentTimeZone Int16[]: ~
  -OSDaylightInEffect Boolean[]: ~
  -OSLastBootUpTime DateTime[]: ~
  -OSMajor UInt32[]: ~
  -OSMinor UInt32[]: ~
  -OSPlatformId UInt32[]: ~
  -OSProductType UInt32[]: ~
  -OSSerialNumber String[]: ~
  -OSSuiteMask UInt32[]: ~
  -PhysicalProcessorCount UInt32[]: ~
  -ServicePackMajor UInt32[]: ~
  -ServicePackMinor UInt32[]: ~
  -SystemDNSHostName String[]: ~
  -SystemDomainName String[]: ~
  -SystemManufacturer String[]: ~
  -SystemProductName String[]: ~
  -SystemSMBIOSUUID String[]: ~
  -SystemSerialNumber String[]: ~
  -ThrottleLimit Int32: ~
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
