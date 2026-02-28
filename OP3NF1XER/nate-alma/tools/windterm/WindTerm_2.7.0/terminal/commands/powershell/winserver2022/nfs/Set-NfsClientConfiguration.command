description: Changes configuration settings for an NFS client
synopses:
- Set-NfsClientConfiguration [-InputObject <CimInstance[]>] [-TransportProtocol <String[]>]
  [-MountType <String>] [-CaseSensitiveLookup <Boolean>] [-MountRetryAttempts <UInt32>]
  [-RpcTimeoutSec <UInt32>] [-UseReservedPorts <Boolean>] [-ReadBufferSize <UInt32>]
  [-WriteBufferSize <UInt32>] [-DefaultAccessMode <UInt32>] [-Authentication <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -Authentication,-Auth String[]:
    values:
    - sys
    - krb5
    - krb5i
    - krb5p
    - default
    - all
  -CaseSensitiveLookup,-casesensitive,-csl Boolean: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DefaultAccessMode,-Access UInt32: ~
  -InputObject CimInstance[]: ~
  -MountRetryAttempts,-retry UInt32: ~
  -MountType,-mtype String:
    values:
    - hard
    - soft
  -PassThru Switch: ~
  -ReadBufferSize,-rsize UInt32: ~
  -RpcTimeoutSec,-timeout,-RpcTimeout UInt32: ~
  -ThrottleLimit Int32: ~
  -TransportProtocol,-protocol String[]:
    values:
    - tcp
    - udp
  -UseReservedPorts Boolean: ~
  -WhatIf,-wi Switch: ~
  -WriteBufferSize,-wsize UInt32: ~
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
