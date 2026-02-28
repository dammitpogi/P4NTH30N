description: Gets Active Directory user, computer, or service accounts
synopses:
- Search-ADAccount [-AccountDisabled] [-AuthType <ADAuthType>] [-ComputersOnly] [-Credential
  <PSCredential>] [-ResultPageSize <Int32>] [-ResultSetSize <Int32>] [-SearchBase
  <String>] [-SearchScope <ADSearchScope>] [-Server <String>] [-UsersOnly] [<CommonParameters>]
- Search-ADAccount [-AccountExpired] [-AuthType <ADAuthType>] [-ComputersOnly] [-Credential
  <PSCredential>] [-ResultPageSize <Int32>] [-ResultSetSize <Int32>] [-SearchBase
  <String>] [-SearchScope <ADSearchScope>] [-Server <String>] [-UsersOnly] [<CommonParameters>]
- Search-ADAccount [-AccountExpiring] [-AuthType <ADAuthType>] [-ComputersOnly] [-Credential
  <PSCredential>] [-DateTime <DateTime>] [-ResultPageSize <Int32>] [-ResultSetSize
  <Int32>] [-SearchBase <String>] [-SearchScope <ADSearchScope>] [-Server <String>]
  [-TimeSpan <TimeSpan>] [-UsersOnly] [<CommonParameters>]
- Search-ADAccount [-AccountInactive] [-AuthType <ADAuthType>] [-ComputersOnly] [-Credential
  <PSCredential>] [-DateTime <DateTime>] [-ResultPageSize <Int32>] [-ResultSetSize
  <Int32>] [-SearchBase <String>] [-SearchScope <ADSearchScope>] [-Server <String>]
  [-TimeSpan <TimeSpan>] [-UsersOnly] [<CommonParameters>]
- Search-ADAccount [-AuthType <ADAuthType>] [-ComputersOnly] [-Credential <PSCredential>]
  [-LockedOut] [-ResultPageSize <Int32>] [-ResultSetSize <Int32>] [-SearchBase <String>]
  [-SearchScope <ADSearchScope>] [-Server <String>] [-UsersOnly] [<CommonParameters>]
- Search-ADAccount [-AuthType <ADAuthType>] [-ComputersOnly] [-Credential <PSCredential>]
  [-PasswordExpired] [-ResultPageSize <Int32>] [-ResultSetSize <Int32>] [-SearchBase
  <String>] [-SearchScope <ADSearchScope>] [-Server <String>] [-UsersOnly] [<CommonParameters>]
- Search-ADAccount [-AuthType <ADAuthType>] [-ComputersOnly] [-Credential <PSCredential>]
  [-PasswordNeverExpires] [-ResultPageSize <Int32>] [-ResultSetSize <Int32>] [-SearchBase
  <String>] [-SearchScope <ADSearchScope>] [-Server <String>] [-UsersOnly] [<CommonParameters>]
options:
  -AccountDisabled Switch:
    required: true
  -AccountExpired Switch:
    required: true
  -AccountExpiring Switch:
    required: true
  -AccountInactive Switch:
    required: true
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -ComputersOnly Switch: ~
  -Credential PSCredential: ~
  -DateTime DateTime: ~
  -LockedOut Switch:
    required: true
  -PasswordExpired Switch:
    required: true
  -PasswordNeverExpires Switch:
    required: true
  -ResultPageSize Int32: ~
  -ResultSetSize Int32: ~
  -SearchBase String: ~
  -SearchScope ADSearchScope:
    values:
    - Base
    - OneLevel
    - Subtree
  -Server String: ~
  -TimeSpan TimeSpan: ~
  -UsersOnly Switch: ~
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
