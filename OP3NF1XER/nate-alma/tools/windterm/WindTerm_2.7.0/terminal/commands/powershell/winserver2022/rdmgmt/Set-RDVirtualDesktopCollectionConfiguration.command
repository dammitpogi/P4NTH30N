description: Changes configuration settings for a virtual desktop collection
synopses:
- Set-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-CollectionDescription
  <String>] [-ClientDeviceRedirectionOptions <RDClientDeviceRedirectionOptions>] [-RedirectAllMonitors
  <Boolean>] [-RedirectClientPrinter <Boolean>] [-SaveDelayMinutes <Int32>] [-UserGroups
  <String[]>] [-AutoAssignPersonalVirtualDesktopToUser <Boolean>] [-GrantAdministrativePrivilege
  <Boolean>] [-CustomRdpProperty <String>] [-ConnectionBroker <String>] [<CommonParameters>]
- Set-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-DisableUserProfileDisks]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Set-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-EnableUserProfileDisks]
  [-IncludeFolderPath <String[]>] [-ExcludeFolderPath <String[]>] [-IncludeFilePath
  <String[]>] [-ExcludeFilePath <String[]>] -MaxUserProfileDiskSizeGB <Int32> -DiskPath
  <String> [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -AutoAssignPersonalVirtualDesktopToUser Boolean: ~
  -ClientDeviceRedirectionOptions RDClientDeviceRedirectionOptions:
    values:
    - None
    - AudioVideoPlayBack
    - AudioRecording
    - COMPort
    - PlugAndPlayDevice
    - SmartCard
    - Clipboard
    - LPTPort
    - Drive
    - TimeZone
  -CollectionDescription String: ~
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -CustomRdpProperty String: ~
  -DisableUserProfileDisks Switch:
    required: true
  -DiskPath String:
    required: true
  -EnableUserProfileDisks Switch:
    required: true
  -ExcludeFilePath String[]: ~
  -ExcludeFolderPath String[]: ~
  -GrantAdministrativePrivilege Boolean: ~
  -IncludeFilePath String[]: ~
  -IncludeFolderPath String[]: ~
  -MaxUserProfileDiskSizeGB Int32:
    required: true
  -RedirectAllMonitors Boolean: ~
  -RedirectClientPrinter Boolean: ~
  -SaveDelayMinutes Int32: ~
  -UserGroups String[]: ~
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
