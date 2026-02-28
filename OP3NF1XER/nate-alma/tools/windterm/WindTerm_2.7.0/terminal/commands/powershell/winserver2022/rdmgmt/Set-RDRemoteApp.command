description: Modifies configuration settings for a RemoteApp program
synopses:
- Set-RDRemoteApp [-CollectionName] <String> -Alias <String> [-DisplayName <String>]
  [-FilePath <String>] [-FileVirtualPath <String>] [-ShowInWebAccess <Boolean>] [-FolderName
  <String>] [-CommandLineSetting <CommandLineSettingValue>] [-RequiredCommandLine
  <String>] [-UserGroups <String[]>] [-IconPath <String>] [-IconIndex <String>] [-ConnectionBroker
  <String>] [<CommonParameters>]
- Set-RDRemoteApp [-CollectionName] <String> -Alias <String> [-DisplayName <String>]
  [-FilePath <String>] [-FileVirtualPath <String>] [-ShowInWebAccess <Boolean>] [-FolderName
  <String>] [-CommandLineSetting <CommandLineSettingValue>] [-RequiredCommandLine
  <String>] [-UserGroups <String[]>] [-IconPath <String>] [-IconIndex <String>] -VirtualDesktopName
  <String> [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -Alias String:
    required: true
  -CollectionName String:
    required: true
  -CommandLineSetting CommandLineSettingValue:
    values:
    - DoNotAllow
    - Allow
    - Require
  -ConnectionBroker String: ~
  -DisplayName String: ~
  -FilePath String: ~
  -FileVirtualPath String: ~
  -FolderName String: ~
  -IconIndex String: ~
  -IconPath String: ~
  -RequiredCommandLine String: ~
  -ShowInWebAccess Boolean: ~
  -UserGroups String[]: ~
  -VirtualDesktopName,-VMName String:
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
