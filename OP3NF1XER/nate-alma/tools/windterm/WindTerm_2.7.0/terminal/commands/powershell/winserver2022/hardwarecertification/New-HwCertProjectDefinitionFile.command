description: Creates an HCK project definition file
synopses:
- New-HwCertProjectDefinitionFile [-ControllerName <String>] [-PdefFilePath <String>]
  [-TestCollectionFilePath <String>] [-EnableIsolateTargets] [-EnableMultiDeviceTest]
  [-OutputAutomatedPdef] [-ProjectName <String>] [-SkipTestStatus <String>] [-CrashDumpCollection
  <String>] [-MachineList <String[]>] [-MachinePool <String>] [-RunSystemTest] [-TestAllDevices]
  [-HwIdList <String[]>] [-DriverList <String[]>] [-ContainerIdList <String[]>] [-ClassIdList
  <String[]>] [<CommonParameters>]
- New-HwCertProjectDefinitionFile [-ControllerName <String>] [-PdefFilePath <String>]
  [-TestCollectionFilePath <String>] [-EnableIsolateTargets] [-EnableMultiDeviceTest]
  [-OutputAutomatedPdef] [-ProjectName <String>] [-SkipTestStatus <String>] [-CrashDumpCollection
  <String>] -MachineList <String[]> [-RunSystemTest] [-TestAllDevices] [-HwIdList
  <String[]>] [-DriverList <String[]>] [-ContainerIdList <String[]>] [-ClassIdList
  <String[]>] [<CommonParameters>]
- New-HwCertProjectDefinitionFile [-ControllerName <String>] [-PdefFilePath <String>]
  [-TestCollectionFilePath <String>] [-EnableIsolateTargets] [-EnableMultiDeviceTest]
  [-OutputAutomatedPdef] [-ProjectName <String>] [-SkipTestStatus <String>] [-CrashDumpCollection
  <String>] -MachinePool <String> [-RunSystemTest] [-TestAllDevices] [-HwIdList <String[]>]
  [-DriverList <String[]>] [-ContainerIdList <String[]>] [-ClassIdList <String[]>]
  [<CommonParameters>]
options:
  -ClassIdList,-ClassList String[]: ~
  -ContainerIdList,-ContainerList String[]: ~
  -ControllerName String: ~
  -CrashDumpCollection String:
    values:
    - Mini
    - Kernel
    - Full
    - Disable
  -DriverList String[]: ~
  -EnableIsolateTargets Switch: ~
  -EnableMultiDeviceTest,-EMDT Switch: ~
  -HwIdList String[]: ~
  -MachineList,-Machine String[]: ~
  -MachinePool,-Pool String: ~
  -OutputAutomatedPdef,-automate Switch: ~
  -PdefFilePath String: ~
  -ProjectName,-PROJ String: ~
  -RunSystemTest,-System Switch: ~
  -SkipTestStatus,-SkipStatus String:
    values:
    - Fail
    - NoData
  -TestAllDevices,-AllDevices Switch: ~
  -TestCollectionFilePath String: ~
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
