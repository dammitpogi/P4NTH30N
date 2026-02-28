description: Sets the WHEA memory policy for a computer
synopses:
- Set-WheaMemoryPolicy [-ComputerName <String>] [-DisableOffline <Boolean>] [-DisablePFA
  <Boolean>] [-PersistMemoryOffline <Boolean>] [-PFAPageCount <UInt32>] [-PFAErrorThreshold
  <UInt32>] [-PFATimeout <UInt32>] [<CommonParameters>]
options:
  -ComputerName,-CN String: ~
  -DisableOffline Boolean: ~
  -DisablePFA Boolean: ~
  -PFAErrorThreshold UInt32: ~
  -PFAPageCount UInt32: ~
  -PFATimeout UInt32: ~
  -PersistMemoryOffline Boolean: ~
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
