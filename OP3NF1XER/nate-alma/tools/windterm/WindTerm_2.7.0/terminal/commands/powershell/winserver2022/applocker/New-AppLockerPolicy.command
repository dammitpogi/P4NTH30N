description: Creates a new AppLocker policy from a list of file information and other
  rule creation options
synopses:
- New-AppLockerPolicy [-FileInformation] <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyModel.FileInformation]>
  [-AllowWindows] [-RuleType <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.RuleType]>]
  [-RuleNamePrefix <String>] [-User <String>] [-Optimize] [-IgnoreMissingFileInformation]
  [-Xml] [-ServiceEnforcement <ServiceEnforcementMode>] [<CommonParameters>]
- New-AppLockerPolicy [-AllowWindows] [-RuleType <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.RuleType]>]
  [-RuleNamePrefix <String>] [-User <String>] [-Optimize] [-IgnoreMissingFileInformation]
  [-Xml] [-ServiceEnforcement <ServiceEnforcementMode>] [<CommonParameters>]
options:
  -AllowWindows Switch: ~
  ? -FileInformation System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyModel.FileInformation]
  : required: true
  -IgnoreMissingFileInformation Switch: ~
  -Optimize Switch: ~
  -RuleNamePrefix String: ~
  -RuleType System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.RuleType]:
    values:
    - Publisher
    - Path
    - Hash
  -ServiceEnforcement ServiceEnforcementMode: ~
  -User String: ~
  -Xml Switch: ~
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
