description: Generates Code Integrity policy rules for user mode code and drivers
synopses:
- New-CIPolicyRule [-DriverFiles <DriverFile[]>] -Level <RuleLevel> [-Fallback <RuleLevel[]>]
  [-Deny] [-ScriptFileNames] [-AllowFileNameFallbacks] [-SpecificFileNameLevel <FileNameLevel>]
  [-UserWriteablePaths] [<CommonParameters>]
- New-CIPolicyRule -DriverFilePath <String[]> [-AppID <String>] -Level <RuleLevel>
  [-Fallback <RuleLevel[]>] [-Deny] [-ScriptFileNames] [-AllowFileNameFallbacks] [-SpecificFileNameLevel
  <FileNameLevel>] [-UserWriteablePaths] [<CommonParameters>]
- New-CIPolicyRule [-Fallback <RuleLevel[]>] [-Deny] [-ScriptFileNames] [-AllowFileNameFallbacks]
  [-SpecificFileNameLevel <FileNameLevel>] [-UserWriteablePaths] [-Package <AppxPackage>]
  [<CommonParameters>]
- New-CIPolicyRule [-Fallback <RuleLevel[]>] [-Deny] [-ScriptFileNames] [-AllowFileNameFallbacks]
  [-SpecificFileNameLevel <FileNameLevel>] [-UserWriteablePaths] [-FilePathRule <String>]
  [<CommonParameters>]
options:
  -AllowFileNameFallbacks Switch: ~
  -AppID String: ~
  -Deny,-d Switch: ~
  -DriverFilePath String[]:
    required: true
  -DriverFiles,-df DriverFile[]: ~
  -Fallback RuleLevel[]:
    values:
    - None
    - Hash
    - FileName
    - FilePath
    - SignedVersion
    - PFN
    - Publisher
    - FilePublisher
    - LeafCertificate
    - PcaCertificate
    - RootCertificate
    - WHQL
    - WHQLPublisher
    - WHQLFilePublisher
  -FilePathRule String: ~
  -Level,-l RuleLevel:
    required: true
    values:
    - None
    - Hash
    - FileName
    - FilePath
    - SignedVersion
    - PFN
    - Publisher
    - FilePublisher
    - LeafCertificate
    - PcaCertificate
    - RootCertificate
    - WHQL
    - WHQLPublisher
    - WHQLFilePublisher
  -Package AppxPackage: ~
  -ScriptFileNames Switch: ~
  -SpecificFileNameLevel FileNameLevel:
    values:
    - None
    - OriginalFileName
    - InternalName
    - FileDescription
    - ProductName
    - PackageFamilyName
  -UserWriteablePaths Switch: ~
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
