description: Creates and links group policies in the specified domain for provisioning
  required access settings on the servers managed by the computer running the IPAM
  server
synopses:
- Invoke-IpamGpoProvisioning [-Domain] <String> [-GpoPrefixName] <String> [-IpamServerFqdn
  <String>] [-DelegatedGpoUser <String[]>] [-DelegatedGpoGroup <String[]>] [-DomainController
  <String>] [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DelegatedGpoGroup String[]: ~
  -DelegatedGpoUser String[]: ~
  -Domain String:
    required: true
  -DomainController String: ~
  -Force Switch: ~
  -GpoPrefixName String:
    required: true
  -IpamServerFqdn String: ~
  -PassThru Switch: ~
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
