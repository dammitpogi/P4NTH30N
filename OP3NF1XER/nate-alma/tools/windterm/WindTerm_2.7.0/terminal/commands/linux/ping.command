description:
  send ICMP ECHO_REQUEST to network hosts
synopses:
  - ping [-aAbBdDfhLnOqrRUvV46] [-c count] [-F flowlabel] [-i interval] [-I interface] [-l preload] [-m mark] [-M pmtudisc_option] [-N nodeinfo_option] [-w deadline] [-W timeout] [-p pattern] [-Q tos] [-s packetsize] [-S sndbuf] [-t ttl] [-T timestamp_option] [hop ...] destination
options:
  -4: Use IPv4 only.
  -6: Use IPv6 only.
  -a: Audible ping.
  -A: AudibleAdaptive ping.
  -b: Allow pinging a broadcast address.
  -B: Do not allow ping to change source address of probes.
  -c count: Stop after sending count ECHO_REQUEST packets. With deadline option, ping waits for count ECHO_REPLY packets, until the timeout expires.
  -d: Set the SO_DEBUG option on the socket being used.
  -D: Print timestamp (unix time + microseconds as in gettimeofday) before each line.
  -f: Flood ping.
  -F flow label: IPv6 only. Allocate and set 20 bit flow label (in hex) on echo request packets. If value is zero, kernel allocates random flow label.
  -h: Show help.
  -i interval: Wait interval seconds between sending each packet.
  -I interface: interface is either an address, or an interface name.
  -l preload: If preload is specified, ping sends that many packets not waiting for reply.
  -L: Suppress loopback of multicast packets. This flag only applies if the ping destination is a multicast address.
  -m mark: use mark to tag the packets going out.
  -M pmtudisc_opt:
    description: Select Path MTU Discovery strategy.
    values:
    - do: prohibit fragmentation, even local one
    - want: do PMTU discovery, fragment locally
    - dont: do not set DF flag
  -N nodeinfo_option:
    description: IPv6 only. Send ICMPv6 Node Information Queries (RFC4620), instead of Echo Request. CAP_NET_RAW capability is required.
    values:
    - help: Show help for NI support.
    - name: Queries for Node Names.
    - ipv6: Queries for IPv6 Addresses.
    - ipv6-global: Request IPv6 global-scope addresses.
    - ipv6-sitelocal: Request IPv6 site-local addresses.
    - ipv6-linklocal: Request IPv6 link-local addresses.
    - ipv6-all: Request IPv6 addresses on other interfaces.
    - ipv4: Queries for IPv4 Addresses.
    - ipv4-all: Request IPv4 addresses on other interfaces.
    - subject-ipv6={ipv6addr}: IPv6 subject address.
    - subject-ipv4={ipv4addr}: IPv4 subject address.
    - subject-name={nodename}: Subject name.
    - subject-fqdn={nodename}: Subject name.
  -n: Numeric output only. No attempt will be made to lookup symbolic names for host addresses.
  -O: Report outstanding ICMP ECHO reply before sending next packet.
  -p pattern: You may specify up to 16 ``pad'' bytes to fill out the packet you send.
  -q: Quiet output. Nothing is displayed except the summary lines at startup time and when finished.
  -Q tos: Set Quality of Service -related bits in ICMP datagrams.
  -r: Bypass the normal routing tables and send directly to a host on an attached interface.
  -R: Record route.
  -s packetsize: Specifies the number of data bytes to be sent.
  -S sndbuf: Set socket sndbuf. If not specified, it is selected to buffer not more than one packet.
  -t ttl: Set the IP Time to Live.
  -T timestamp option:
    description: Set special IP timestamp options.
    values:
    - tsonly: only timestamps
    - tsandaddr: timestamps and addresses
    - tsprespec: timestamp prespecified hops
  -U: Print full user-to-user latency (the old behaviour).
  -v: Verbose output.
  -V: Show version and exit.
  -w deadline: Specify a timeout, in seconds, before ping exits regardless of how many packets have been sent or received.
  -W timeout: Time to wait for a response, in seconds.