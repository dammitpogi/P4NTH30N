description: Sets local certificate auto-enrollment policy
synopses:
- Set-CertificateAutoEnrollmentPolicy [-StoreName <String[]>] -PolicyState <PolicySetting>
  [-ExpirationPercentage <Int32>] [-EnableTemplateCheck] [-EnableMyStoreManagement]
  [-EnableBalloonNotifications] -context <Context> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-CertificateAutoEnrollmentPolicy [-EnableAll] -context <Context> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -EnableAll Switch:
    required: true
  -EnableBalloonNotifications Switch: ~
  -EnableMyStoreManagement Switch: ~
  -EnableTemplateCheck Switch: ~
  -ExpirationPercentage Int32: ~
  -PolicyState PolicySetting:
    required: true
    values:
    - NotConfigured
    - Enabled
    - Disabled
  -StoreName String[]: ~
  -WhatIf,-wi Switch: ~
  -context Context:
    required: true
    values:
    - Machine
    - User
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
