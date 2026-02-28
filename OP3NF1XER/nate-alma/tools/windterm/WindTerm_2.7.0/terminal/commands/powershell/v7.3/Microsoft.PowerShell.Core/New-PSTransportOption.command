description: Creates an object that contains advanced options for a session configuration
synopses:
- New-PSTransportOption [-MaxIdleTimeoutSec <Int32>] [-ProcessIdleTimeoutSec <Int32>]
  [-MaxSessions <Int32>] [-MaxConcurrentCommandsPerSession <Int32>] [-MaxSessionsPerUser
  <Int32>] [-MaxMemoryPerSessionMB <Int32>] [-MaxProcessesPerSession <Int32>] [-MaxConcurrentUsers
  <Int32>] [-IdleTimeoutSec <Int32>] [-OutputBufferingMode <OutputBufferingMode>]
  [<CommonParameters>]
options:
  -IdleTimeoutSec System.Nullable`1[System.Int32]: ~
  -MaxConcurrentCommandsPerSession System.Nullable`1[System.Int32]: ~
  -MaxConcurrentUsers System.Nullable`1[System.Int32]: ~
  -MaxIdleTimeoutSec System.Nullable`1[System.Int32]: ~
  -MaxMemoryPerSessionMB System.Nullable`1[System.Int32]: ~
  -MaxProcessesPerSession System.Nullable`1[System.Int32]: ~
  -MaxSessions System.Nullable`1[System.Int32]: ~
  -MaxSessionsPerUser System.Nullable`1[System.Int32]: ~
  -OutputBufferingMode System.Nullable`1[System.Management.Automation.Runspaces.OutputBufferingMode]:
    values:
    - None
    - Drop
    - Block
  -ProcessIdleTimeoutSec System.Nullable`1[System.Int32]: ~
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
