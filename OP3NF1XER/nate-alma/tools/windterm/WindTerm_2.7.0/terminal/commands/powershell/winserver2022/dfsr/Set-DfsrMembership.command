description: Configures membership settings for replication group members
synopses:
- Set-DfsrMembership [-GroupName] <String[]> [-FolderName] <String[]> [-ComputerName]
  <String[]> [[-ContentPath] <String>] [[-PrimaryMember] <Boolean>] [[-StagingPath]
  <String>] [[-StagingPathQuotaInMB] <UInt32>] [[-ConflictAndDeletedQuotaInMB] <UInt32>]
  [[-ReadOnly] <Boolean>] [[-RemoveDeletedFiles] <Boolean>] [[-DisableMembership]
  <Boolean>] [[-MinimumFileStagingSize] <FileStagingSize>] [[-DfsnPath] <String>]
  [-Force] [[-DomainName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-MemberList,-MemList String[]:
    required: true
  -Confirm,-cf Switch: ~
  -ConflictAndDeletedQuotaInMB UInt32: ~
  -ContentPath String: ~
  -DfsnPath String: ~
  -DisableMembership Boolean: ~
  -DomainName String: ~
  -FolderName,-RF,-RfName String[]:
    required: true
  -Force Switch: ~
  -GroupName,-RG,-RgName String[]:
    required: true
  -MinimumFileStagingSize FileStagingSize:
    values:
    - Size256KB
    - Size512KB
    - Size1MB
    - Size2MB
    - Size4MB
    - Size8MB
    - Size16MB
    - Size32MB
    - Size64MB
    - Size128MB
    - Size256MB
    - Size512MB
    - Size1GB
    - Size2GB
    - Size4GB
    - Size8GB
    - Size16GB
    - Size32GB
    - Size64GB
    - Size128GB
    - Size256GB
    - Size512GB
    - Size1TB
    - Size2TB
    - Size4TB
    - Size8TB
    - Size16TB
    - Size32TB
    - Size64TB
    - Size128TB
    - Size256TB
    - Size512TB
  -PrimaryMember Boolean: ~
  -ReadOnly Boolean: ~
  -RemoveDeletedFiles Boolean: ~
  -StagingPath String: ~
  -StagingPathQuotaInMB UInt32: ~
  -WhatIf,-wi Switch: ~
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
