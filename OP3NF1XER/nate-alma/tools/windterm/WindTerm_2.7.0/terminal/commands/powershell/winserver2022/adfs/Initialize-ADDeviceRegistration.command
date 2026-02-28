description: Initializes the Device Registration Service configuration in the Active
  Directory forest
synopses:
- Initialize-ADDeviceRegistration -ServiceAccountName <String> [-DeviceLocation <String>]
  [-RegistrationQuota <UInt32>] [-MaximumRegistrationInactivityPeriod <UInt32>] [-Credential
  <PSCredential>] [-Force] [-DiscoveryName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Credential PSCredential: ~
  -DeviceLocation String: ~
  -DiscoveryName String: ~
  -Force Switch: ~
  -MaximumRegistrationInactivityPeriod UInt32: ~
  -RegistrationQuota UInt32: ~
  -ServiceAccountName String:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
