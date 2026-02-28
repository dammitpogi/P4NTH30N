description: Creates a volume ID qualifier
synopses:
- New-VolumeIDQualifier [-VolumeSignatureCatalogFilePath] <String> [-VersionRule]
  <VolumeVersionRule> [<CommonParameters>]
- New-VolumeIDQualifier [-TemplateDiskFilePath] <String> [-VersionRule] <VolumeVersionRule>
  [<CommonParameters>]
options:
  -TemplateDiskFilePath String:
    required: true
  -VersionRule VolumeVersionRule:
    required: true
    values:
    - Equals
    - GreaterThan
    - GreaterThanOrEquals
  -VolumeSignatureCatalogFilePath String:
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
