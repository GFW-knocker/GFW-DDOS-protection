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


# pure ufw rate-limit (if you dont like iptables)
Rate limit traffic to your webserver with UFW.
This is the UFW rules we add to our \etc\ufw\before.rules in UFW to prevent DDoS attacks on our webservers.
Adjustments can be made depending on ligitimate traffic to the webserver.
Works with Debian 9 / 10 Servers and Ubuntu 18.04 & 20.04 Server.
# Usage:
Add these lines to /etc/ufw/before.rules after<br>
<code># End required lines</code>
1. Add these lines</br>
<code># Start CUSTOM UFW added by clusterednetworks 2020-10-20</code><br>
<code># Limit to 20 concurrent connections on port 80/443 per IP</code><br>
<code>-A ufw-before-input -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 -j DROP</code><br>
<code>-A ufw-before-input -p tcp --syn --dport 443 -m connlimit --connlimit-above 20 -j DROP</code><br>
<code># Limit to 20 connections on port 80/443 per 2 seconds per IP</code><br>
<code>-A ufw-before-input -p tcp --dport 80 -i eth0 -m state --state NEW -m recent --set</code><br>
<code>-A ufw-before-input -p tcp --dport 80 -i eth0 -m state --state NEW -m recent --update --seconds 2 --hitcount 20 -j DROP</code><br>
<code>-A ufw-before-input -p tcp --dport 443 -i eth0 -m state --state NEW -m recent --set</code><br>
<code>-A ufw-before-input -p tcp --dport 443 -i eth0 -m state --state NEW -m recent --update --seconds 2 --hitcount 20 -j DROP</code><br>
<code># End Custom UFW by clusterednetworks</code><br>

2. Reload the filewall rules<br>
<code>sudo ufw reload</code>
