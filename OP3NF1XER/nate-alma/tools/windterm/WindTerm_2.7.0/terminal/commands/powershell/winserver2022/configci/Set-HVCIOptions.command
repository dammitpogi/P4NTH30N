description: Modifies hypervisor Code Integrity options for a policy
synopses:
- Set-HVCIOptions [-Enabled] [-Strict] [-DebugMode] [-DisableAllowed] [-FilePath]
  <String> [<CommonParameters>]
- Set-HVCIOptions [-None] [-FilePath] <String> [<CommonParameters>]
options:
  -DebugMode Switch: ~
  -DisableAllowed Switch: ~
  -Enabled Switch: ~
  -FilePath,-f String:
    required: true
  -None Switch: ~
  -Strict Switch: ~
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
