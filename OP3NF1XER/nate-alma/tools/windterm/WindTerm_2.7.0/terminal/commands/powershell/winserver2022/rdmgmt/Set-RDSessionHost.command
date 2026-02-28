description: Configures one or more RD Session Host servers in a session collection
synopses:
- Set-RDSessionHost [-SessionHost] <String[]> [-NewConnectionAllowed] <RDServerNewConnectionAllowed>
  [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -NewConnectionAllowed RDServerNewConnectionAllowed:
    required: true
    values:
    - Yes
    - NotUntilReboot
    - No
  -SessionHost String[]:
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
