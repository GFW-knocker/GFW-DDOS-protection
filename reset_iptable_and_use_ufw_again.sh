iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -t nat -F
iptables -t mangle -F
iptables -t nat -X
iptables -t mangle -X
iptables -F
iptables -X

ufw --force disable
ufw --force enable

