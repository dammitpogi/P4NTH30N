description:
  This diagnostic tool determines the path taken to a destination by sending Internet Control Message Protocol (ICMP) echo Request or ICMPv6 messages to the destination with incrementally increasing time to live (TTL) field values.
synopses:
  - tracert [/d] [/h <maximumhops>] [/j <hostlist>] [/w <timeout>] [/R] [/S <srcaddr>]
    [/4][/6] <targetname>
options:
  /d: Stops attempts to resolve the IP addresses of intermediate routers to their names. This can speed up the return of results.
  /h <maximumhops>: Specifies the maximum number of hops in the path to search for the target (destination). The default is 30 hops.
  /j <hostlist>: Specifies that echo Request messages use the Loose Source Route option in the IP header with the set of intermediate destinations specified in <hostlist>.
  /w <timeout>: Specifies the amount of time in milliseconds to wait for the ICMP time Exceeded or echo Reply message corresponding to a given echo Request message to be received. The default time-out is 4000 (4 seconds).
  /R: Specifies that the IPv6 Routing extension header be used to send an echo Request message to the local host, using the destination as an intermediate destination and testing the reverse route.
  /S <srcaddr>: Specifies the source address to use in the echo Request messages. Use this parameter only when tracing IPv6 addresses.
  /4: Specifies that tracert.exe can use only IPv4 for this trace.
  /6: Specifies that tracert.exe can use only IPv6 for this trace.
  /?: Displays help at the command prompt.