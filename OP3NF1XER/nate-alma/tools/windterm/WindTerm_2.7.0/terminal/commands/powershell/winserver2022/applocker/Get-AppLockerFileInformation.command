description: Gets the file information necessary to create AppLocker rules from a
  list of files or an event log
synopses:
- Get-AppLockerFileInformation [[-Path] <System.Collections.Generic.List`1[System.String]>]
  [<CommonParameters>]
- Get-AppLockerFileInformation [[-Packages] <System.Collections.Generic.List`1[Microsoft.Windows.Appx.PackageManager.Commands.AppxPackage]>]
  [<CommonParameters>]
- Get-AppLockerFileInformation -Directory <String> [-FileType <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyModel.AppLockerFileType]>]
  [-Recurse] [<CommonParameters>]
- Get-AppLockerFileInformation [-EventLog] [-LogPath <String>] [-EventType <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.Cmdlets.AppLockerEventType]>]
  [-Statistics] [<CommonParameters>]
options:
  -Directory String:
    required: true
  -EventLog Switch:
    required: true
  -EventType System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.Cmdlets.AppLockerEventType]:
    values:
    - Allowed
    - Denied
    - Audited
  ? -FileType System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyModel.AppLockerFileType]
  : values:
    - Exe
    - Dll
    - WindowsInstaller
    - Script
    - Appx
  -LogPath String: ~
  -Packages System.Collections.Generic.List`1[Microsoft.Windows.Appx.PackageManager.Commands.AppxPackage]: ~
  -Path System.Collections.Generic.List`1[System.String]: ~
  -Recurse Switch: ~
  -Statistics Switch: ~
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
