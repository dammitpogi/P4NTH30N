description: Gets the global TCP/IP offload settings
synopses:
- Get-NetOffloadGlobalSetting [-ReceiveSideScaling <EnabledDisabledEnum[]>] [-ReceiveSegmentCoalescing
  <EnabledDisabledEnum[]>] [-Chimney <ChimneyEnum[]>] [-TaskOffload <EnabledDisabledEnum[]>]
  [-NetworkDirect <EnabledDisabledEnum[]>] [-NetworkDirectAcrossIPSubnets <AllowedBlockedEnum[]>]
  [-PacketCoalescingFilter <EnabledDisabledEnum[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -Chimney ChimneyEnum[]:
    values:
    - Disabled
    - Enabled
    - Automatic
  -CimSession,-Session CimSession[]: ~
  -NetworkDirect EnabledDisabledEnum[]:
    values:
    - Disabled
    - Enabled
  -NetworkDirectAcrossIPSubnets AllowedBlockedEnum[]:
    values:
    - Blocked
    - Allowed
  -PacketCoalescingFilter EnabledDisabledEnum[]:
    values:
    - Disabled
    - Enabled
  -ReceiveSegmentCoalescing EnabledDisabledEnum[]:
    values:
    - Disabled
    - Enabled
  -ReceiveSideScaling EnabledDisabledEnum[]:
    values:
    - Disabled
    - Enabled
  -TaskOffload EnabledDisabledEnum[]:
    values:
    - Disabled
    - Enabled
  -ThrottleLimit Int32: ~
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
