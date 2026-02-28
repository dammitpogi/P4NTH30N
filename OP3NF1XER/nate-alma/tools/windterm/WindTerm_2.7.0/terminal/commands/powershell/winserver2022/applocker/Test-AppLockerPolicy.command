description: Specifies the AppLocker policy to determine whether the input files will
  be allowed to run for a given user
synopses:
- Test-AppLockerPolicy [-XmlPolicy] <String> -Path <System.Collections.Generic.List`1[System.String]>
  [-User <String>] [-Filter <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyDecision]>]
  [<CommonParameters>]
- Test-AppLockerPolicy [-XmlPolicy] <String> -Packages <System.Collections.Generic.List`1[Microsoft.Windows.Appx.PackageManager.Commands.AppxPackage]>
  [-User <String>] [-Filter <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyDecision]>]
  [<CommonParameters>]
- Test-AppLockerPolicy [-PolicyObject] <AppLockerPolicy> -Path <System.Collections.Generic.List`1[System.String]>
  [-User <String>] [-Filter <System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyDecision]>]
  [<CommonParameters>]
options:
  -Filter System.Collections.Generic.List`1[Microsoft.Security.ApplicationId.PolicyManagement.PolicyDecision]:
    values:
    - Allowed
    - AllowedByDefault
    - Denied
    - DeniedByDefault
  -Packages System.Collections.Generic.List`1[Microsoft.Windows.Appx.PackageManager.Commands.AppxPackage]:
    required: true
  -Path System.Collections.Generic.List`1[System.String]:
    required: true
  -PolicyObject AppLockerPolicy:
    required: true
  -User String: ~
  -XmlPolicy String:
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
