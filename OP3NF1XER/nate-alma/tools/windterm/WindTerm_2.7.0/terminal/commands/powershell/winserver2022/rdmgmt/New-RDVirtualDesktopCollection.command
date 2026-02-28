description: Creates a virtual desktop collection
synopses:
- New-RDVirtualDesktopCollection [-PooledManaged] [-CollectionName] <String> [-Description
  <String>] [-UserGroups <String[]>] [-ConnectionBroker <String>] -VirtualDesktopTemplateName
  <String> -VirtualDesktopTemplateHostServer <String> -VirtualDesktopAllocation <Hashtable>
  -StorageType <VirtualDesktopStorageType> [-CentralStoragePath <String>] [-LocalStoragePath
  <String>] [-VirtualDesktopTemplateStoragePath <String>] [-Domain <String>] [-OU
  <String>] [-CustomSysprepUnattendFilePath <String>] [-VirtualDesktopNamePrefix <String>]
  [-DisableVirtualDesktopRollback] [-VirtualDesktopPasswordAge <Int32>] [-UserProfileDiskPath
  <String>] [-MaxUserProfileDiskSizeGB <Int32>] [-Force] [<CommonParameters>]
- New-RDVirtualDesktopCollection [-PersonalManaged] [-CollectionName] <String> [-Description
  <String>] [-UserGroups <String[]>] [-ConnectionBroker <String>] -VirtualDesktopTemplateName
  <String> -VirtualDesktopTemplateHostServer <String> -VirtualDesktopAllocation <Hashtable>
  -StorageType <VirtualDesktopStorageType> [-CentralStoragePath <String>] [-LocalStoragePath
  <String>] [-Domain <String>] [-OU <String>] [-CustomSysprepUnattendFilePath <String>]
  [-VirtualDesktopNamePrefix <String>] [-AutoAssignPersonalVirtualDesktopToUser] [-GrantAdministrativePrivilege]
  [-Force] [<CommonParameters>]
- New-RDVirtualDesktopCollection [-PooledUnmanaged] [-CollectionName] <String> [-Description
  <String>] [-UserGroups <String[]>] [-ConnectionBroker <String>] -VirtualDesktopName
  <String[]> [-UserProfileDiskPath <String>] [-MaxUserProfileDiskSizeGB <Int32>] [-Force]
  [<CommonParameters>]
- New-RDVirtualDesktopCollection [-PersonalUnmanaged] [-CollectionName] <String> [-Description
  <String>] [-UserGroups <String[]>] [-ConnectionBroker <String>] -VirtualDesktopName
  <String[]> [-AutoAssignPersonalVirtualDesktopToUser] [-GrantAdministrativePrivilege]
  [-Force] [<CommonParameters>]
options:
  -AutoAssignPersonalVirtualDesktopToUser Switch: ~
  -CentralStoragePath String: ~
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -CustomSysprepUnattendFilePath String: ~
  -Description String: ~
  -DisableVirtualDesktopRollback Switch: ~
  -Domain String: ~
  -Force Switch: ~
  -GrantAdministrativePrivilege Switch: ~
  -LocalStoragePath String: ~
  -MaxUserProfileDiskSizeGB Int32: ~
  -OU String: ~
  -PersonalManaged Switch:
    required: true
  -PersonalUnmanaged Switch:
    required: true
  -PooledManaged Switch:
    required: true
  -PooledUnmanaged Switch:
    required: true
  -StorageType VirtualDesktopStorageType:
    required: true
    values:
    - LocalStorage
    - CentralSmbShareStorage
    - CentralSanStorage
  -UserGroups String[]: ~
  -UserProfileDiskPath String: ~
  -VirtualDesktopAllocation Hashtable:
    required: true
  -VirtualDesktopName String[]:
    required: true
  -VirtualDesktopNamePrefix String: ~
  -VirtualDesktopPasswordAge Int32: ~
  -VirtualDesktopTemplateHostServer String:
    required: true
  -VirtualDesktopTemplateName String:
    required: true
  -VirtualDesktopTemplateStoragePath String: ~
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
