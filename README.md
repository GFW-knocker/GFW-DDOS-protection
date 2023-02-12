# GFW-DDOS-protection:
iptables rules to protect against GFW-prober DDOS and port scanning

# motivation:
- we notice that GFW-probers sometimes flood v2ray server with thousands of simoltaneous connection
- if xray port opened without protection , sometimes number of tcp connections raise up to +50K , little after IP get blocked
- we log all IP and all requests using this tool: https://github.com/GFW-knocker/gfw_resist_http_proxy
- we identify that this behavior is due to DDOS-like attack of GFW node to probe vpn server and block them

# how this protection work:
- it is set of iptables rules (firewall)
- block all ICMP/ping
- limit rate of tcp request to 20/sec per IP
- limit total established connection to 100 per IP
- limit total packet to 2000/sec per IP (~2MB/s download speed)
- port scan protection (IP blocked for 30min if scan +5 port)



# pure ufw rate-limit (if you dont like iptables)

0. open file /etc/ufw/before.rules<br>
<code>sudo vim /etc/ufw/before.rules</code><br><br>
1. Add those lines after *filter near the beginning of the file:<br>
<code>:ufw-http - [0:0]</code><br>
<code>:ufw-http-logdrop - [0:0]</code><br>

2. Add those lines near the end of the file, before the COMMIT:<br>  
<code>### start ###</code><br>
<code># Entry point - add your xray port here instead of 80 or 443</code><br>
<code>-A ufw-before-input -p tcp --dport 80 -j ufw-http</code><br>
<code>-A ufw-before-input -p tcp --dport 443 -j ufw-http</code><br><br>
<code># Limit 100 established connections per IP</code><br>
<code>-A ufw-http -p tcp --syn -m connlimit --connlimit-above 100 --connlimit-mask 24 -j ufw-http-logdrop</code><br><br>
<code># Limit 20 new connections per IP per sec</code><br>
<code>-A ufw-http -m state --state NEW -m recent --name conn_per_ip --set</code><br>
<code>-A ufw-http -m state --state NEW -m recent --name conn_per_ip --update --seconds 1 --hitcount 20 -j ufw-http-logdrop</code><br><br>
<code># Finally accept</code><br>
<code>-A ufw-http -j ACCEPT</code><br><br>
<code># Log</code><br>
<code>-A ufw-http-logdrop -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW HTTP DROP] "</code><br>
<code>-A ufw-http-logdrop -j DROP</code><br>
<code>### end ###</code><br><br>

3. reload ufw:<br>
<code>sudo ufw reload</code><br>

    
# how to run script:
- set permission:

    chmod +x srcipt.sh
- run with root user:

    ./script.sh
- rules applied immidiately but you need to run this after every restart


# iptables user manual:
- https://web.mit.edu/rhel-doc/4/RH-DOCS/rhel-rg-en-4/s1-iptables-options.html
- https://bookofzeus.com/harden-ubuntu/hardening/protect-ddos-attacks/
- https://javapipe.com/blog/iptables-ddos-protection/
