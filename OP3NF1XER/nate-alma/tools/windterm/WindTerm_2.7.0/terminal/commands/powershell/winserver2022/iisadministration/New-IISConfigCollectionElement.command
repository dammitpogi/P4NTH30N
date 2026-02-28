description: Creates a new configuration element object in an IIS configuration collection
synopses:
- New-IISConfigCollectionElement [-ConfigCollection] <ConfigurationElementCollection>
  [-ConfigAttribute] <Hashtable> [[-AddAt] <UInt32>] [-Passthru] [<CommonParameters>]
options:
  -AddAt UInt32: ~
  -ConfigAttribute Hashtable:
    required: true
  -ConfigCollection ConfigurationElementCollection:
    required: true
  -Passthru Switch: ~
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
