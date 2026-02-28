description: Creates a main mode authentication proposal that specifies a suite of
  authentication protocols to offer in IPsec main mode negotiations with other computers
synopses:
- New-NetIPsecAuthProposal [-AccountMapping] -Authority <String> [-AuthorityType <CertificateAuthorityType>]
  [-Cert] [-ExtendedKeyUsage <String[]>] [-ExcludeCAName] [-FollowRenewal] [-Health]
  [-Machine] [-SelectionCriteria] [-Signing <CertificateSigningAlgorithm>] [-SubjectName
  <String>] [-SubjectNameType <CertificateSubjectType>] [-Thumbprint <String>] [-ValidationCriteria]
  [<CommonParameters>]
- New-NetIPsecAuthProposal [-AccountMapping] -Authority <String> [-AuthorityType <CertificateAuthorityType>]
  [-Cert] [-ExtendedKeyUsage <String[]>] [-ExcludeCAName] [-FollowRenewal] [-SelectionCriteria]
  [-Signing <CertificateSigningAlgorithm>] [-SubjectName <String>] [-SubjectNameType
  <CertificateSubjectType>] [-Thumbprint <String>] [-User] [-ValidationCriteria] [<CommonParameters>]
- New-NetIPsecAuthProposal [-Anonymous] [<CommonParameters>]
- New-NetIPsecAuthProposal [-Kerberos] [-Machine] [-Proxy <String>] [<CommonParameters>]
- New-NetIPsecAuthProposal [-Kerberos] [-Proxy <String>] [-User] [<CommonParameters>]
- New-NetIPsecAuthProposal [-Machine] [-Ntlm] [<CommonParameters>]
- New-NetIPsecAuthProposal [-Machine] [-PreSharedKey] <String> [<CommonParameters>]
- New-NetIPsecAuthProposal [-Ntlm] [-User] [<CommonParameters>]
options:
  -AccountMapping Switch: ~
  -Anonymous Switch:
    required: true
  -Authority String:
    required: true
  -AuthorityType CertificateAuthorityType:
    values:
    - Invalid
    - Root
    - Intermediate
  -Cert Switch:
    required: true
  -ExcludeCAName Switch: ~
  -ExtendedKeyUsage,-EKUs String[]: ~
  -FollowRenewal Switch: ~
  -Health Switch: ~
  -Kerberos Switch:
    required: true
  -Machine Switch:
    required: true
  -Ntlm Switch:
    required: true
  -PreSharedKey,-PSK String:
    required: true
  -Proxy String: ~
  -SelectionCriteria Switch: ~
  -Signing CertificateSigningAlgorithm:
    values:
    - Invalid
    - RSA
    - ECDSA256
    - ECDSA384
  -SubjectName String: ~
  -SubjectNameType CertificateSubjectType:
    values:
    - None
    - DomainName
    - UserPrincipalName
    - EmailAddress
    - CN
    - OU
    - O
    - DC
  -Thumbprint String: ~
  -User Switch:
    required: true
  -ValidationCriteria Switch: ~
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
