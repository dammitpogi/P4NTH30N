description: Scans for drivers on the system
synopses:
- Get-SystemDriver [-Audit] [-ScanPath <String>] [-UserPEs] [-NoScript] [-NoShadowCopy]
  [-OmitPaths <String[]>] [-PathToCatroot <String>] [-ScriptFileNames] [<CommonParameters>]
options:
  -Audit,-a Switch: ~
  -NoScript Switch: ~
  -NoShadowCopy Switch: ~
  -OmitPaths,-o String[]: ~
  -PathToCatroot,-c String: ~
  -ScanPath,-s String: ~
  -ScriptFileNames Switch: ~
  -UserPEs,-u Switch: ~
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
