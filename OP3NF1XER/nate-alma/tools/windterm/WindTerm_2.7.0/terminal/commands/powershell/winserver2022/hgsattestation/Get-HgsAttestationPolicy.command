description: Gets HGS attestation policies
synopses:
- Get-HgsAttestationPolicy [[-Name] <String>] [-State <AttestationPolicyState>] [-PolicyType
  <AttestationPolicyType[]>] [-PolicyVersion <PolicyVersion>] [-Stage] [<CommonParameters>]
options:
  -Name String: ~
  -PolicyType AttestationPolicyType[]:
    values:
    - Unknown
    - SecureBootEnabled
    - SecureBootSettings
    - CiPolicy
    - UefiDebugDisabled
    - FullBoot
    - VsmIdkPresent
    - BitLockerEnabled
    - IommuEnabled
    - PagefileEncryptionEnabled
    - HypervisorEnforcedCiPolicy
    - NoHibernation
    - NoDumps
    - DumpEncryption
    - DumpEncryptionKey
  -PolicyVersion PolicyVersion:
    values:
    - None
    - PolicyVersion1503
    - PolicyVersion1704
  -Stage Switch: ~
  -State AttestationPolicyState:
    values:
    - Disabled
    - Enabled
    - Locked
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
