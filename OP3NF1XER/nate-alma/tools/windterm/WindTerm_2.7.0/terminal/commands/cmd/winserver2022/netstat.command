description:
  Displays active TCP connections, ports on which the computer is listening.
synopses:
  - netstat [-a] [-b] [-e] [-n] [-o] [-p <Protocol>] [-r] [-s] [<interval>]
options:
  -a: Displays all active TCP connections and the TCP and UDP ports on which the computer is listening.
  -e: Displays Ethernet statistics, such as the number of bytes and packets sent and received.
  -n: Displays active TCP connections, however, addresses and port numbers are expressed numerically and no attempt is made to determine names.
  -o: Displays active TCP connections and includes the process ID (PID) for each connection.
  -p <Protocol>:
    description: Shows connections for the protocol specified by Protocol.
    values:
      - icmp
      - icmpv6
      - ip
      - ipv6
      - tcp
      - tcpv6
      - udp
      - udpv6
  -s: Displays statistics by protocol.
  -r: Displays the contents of the IP routing table. This is equivalent to the route print command.
  /?: Displays help at the command prompt.