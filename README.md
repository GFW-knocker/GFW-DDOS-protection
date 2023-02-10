# GFW-DDOS-protection:
iptables rules to protect against GFW-prober DDOS and port scanning

# motivation:
- we notice that GFW-probers sometimes flood v2ray server with thousands of simoltaneous connection
- if xray port opened without protection , sometimes number of tcp connections raise up to +50K , little after IP get blocked
- we log all IP and all requests using this tool: https://github.com/GFW-knocker/gfw_resist_http_proxy
- we identify that this behavior is due to DDOS-like attack of GFW node to probe vpn server and block them

# how this protection work:
- it is set of iptables rules (firewall)
- block all ICMP/ping (#6)
- limit rate of tcp request to 60/sec per IP (#10)
- limit total established connection to 111 per IP (#8)
- protect against port scanning (#12)


# how to run:
- set permission:

    chmod +x ddos_iptable.sh
- run with root user:

    ./ddos_iptable.sh
- rules applied immidiately but you need to run this after every restart


# iptables user manual:
- https://web.mit.edu/rhel-doc/4/RH-DOCS/rhel-rg-en-4/s1-iptables-options.html
- https://javapipe.com/blog/iptables-ddos-protection/
