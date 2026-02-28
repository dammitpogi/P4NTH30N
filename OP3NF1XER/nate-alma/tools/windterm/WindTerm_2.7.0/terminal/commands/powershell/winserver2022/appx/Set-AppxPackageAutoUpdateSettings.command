description: The `Get-AppxPackageAutoUpdateSettings` PowerShell cmdlet is only available
  in the Windows Insider Preview Builds of Windows 10. The `Set-AppxPackageAutoUpdateSettings`
  PowerShell cmdlet provides access to configure a specific Windows App's Auto Update
  and Repair settings. Including pausing update checks
synopses:
- Set-AppxPackageAutoUpdateSettings [-PackageFamilyName] <String> -AppInstallerUri
  <String> [-UpdateUris <String[]>] [-RepairUris <String[]>] [-OptionalPackages <String[]>]
  [-DependencyPackages <String[]>] [-EnableAutomaticBackgroundTask] [-ForceUpdateFromAnyVersion]
  [-DisableAutoRepairs] [-CheckOnLaunch] [-ShowPrompt] [-UpdateBlocksActivation] [-UseSystemPolicySource]
  [-HoursBetweenUpdateChecks <UInt32>] [-Version <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AppxPackageAutoUpdateSettings [-PackageFamilyName] <String> [-PauseUpdates]
  [-UseSystemPolicySource] -HoursToPause <UInt32> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -HoursToPause UInt32:
    required: true
  -PauseUpdates Switch:
    required: true
  -PackageFamilyName String:
    required: true
  -AppInstallerUri String:
    required: true
  -CheckOnLaunch Switch: ~
  -DependencyPackages String[]: ~
  -DisableAutoRepairs Switch: ~
  -EnableAutomaticBackgroundTask Switch: ~
  -ForceUpdateFromAnyVersion Switch: ~
  -HoursBetweenUpdateChecks UInt32: ~
  -OptionalPackages String[]: ~
  -RepairUris String[]: ~
  -ShowPrompt Switch: ~
  -UpdateBlocksActivation Switch: ~
  -UpdateUris String[]: ~
  -UseSystemPolicySource Switch: ~
  -Version String: ~
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
