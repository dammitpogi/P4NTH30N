description: Creates a Code Integrity policy as an .xml file
synopses:
- New-CIPolicy [-FilePath] <String> [-DriverFiles <DriverFile[]>] -Level <RuleLevel>
  [-Fallback <RuleLevel[]>] [-Audit] [-ScanPath <String>] [-ScriptFileNames] [-AllowFileNameFallbacks]
  [-SpecificFileNameLevel <FileNameLevel>] [-UserWriteablePaths] [-UserPEs] [-NoScript]
  [-Deny] [-NoShadowCopy] [-MultiplePolicyFormat] [-OmitPaths <String[]>] [-PathToCatroot
  <String>] [-AppIdTaggingPolicy] [-AppIdTaggingKey <String[]>] [-AppIdTaggingValue
  <String[]>] [<CommonParameters>]
- New-CIPolicy [-FilePath] <String> -Rules <Rule[]> [-Audit] [-ScanPath <String>]
  [-ScriptFileNames] [-AllowFileNameFallbacks] [-SpecificFileNameLevel <FileNameLevel>]
  [-UserWriteablePaths] [-UserPEs] [-NoScript] [-Deny] [-NoShadowCopy] [-MultiplePolicyFormat]
  [-OmitPaths <String[]>] [-PathToCatroot <String>] [-AppIdTaggingPolicy] [-AppIdTaggingKey
  <String[]>] [-AppIdTaggingValue <String[]>] [<CommonParameters>]
options:
  -AllowFileNameFallbacks Switch: ~
  -AppIdTaggingKey String[]: ~
  -AppIdTaggingPolicy Switch: ~
  -AppIdTaggingValue String[]: ~
  -Audit,-a Switch: ~
  -Deny,-d Switch: ~
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
  -FilePath,-f String:
    required: true
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
  -MultiplePolicyFormat Switch: ~
  -NoScript Switch: ~
  -NoShadowCopy Switch: ~
  -OmitPaths,-o String[]: ~
  -PathToCatroot,-c String: ~
  -Rules,-r Rule[]:
    required: true
  -ScanPath,-s String: ~
  -ScriptFileNames Switch: ~
  -SpecificFileNameLevel FileNameLevel: ~
  -UserPEs,-u Switch: ~
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
