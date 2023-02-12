apt-get install ipset

### https://unix.stackexchange.com/questions/345114/how-to-protect-against-port-scanners ###

ipset create port_scanners hash:ip family inet hashsize 32768 maxelem 65536 timeout 1800
ipset create scanned_ports hash:ip,port family inet hashsize 32768 maxelem 65536 timeout 60

iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -m state --state NEW -m set ! --match-set scanned_ports src,dst -m hashlimit --hashlimit-above 1/hour --hashlimit-burst 5 --hashlimit-mode srcip --hashlimit-name portscan --hashlimit-htable-expire 10000 -j SET --add-set port_scanners src --exist
iptables -A INPUT -m state --state NEW -m set --match-set port_scanners src -j DROP
iptables -A INPUT -m state --state NEW -j SET --add-set scanned_ports src,dst

echo "port scan Protection applied!"
