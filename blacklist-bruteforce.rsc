## use the raw filter to conserve CPU cycles
/ip firewall raw
add chain=prerouting src-address-list=_bruteforce_blacklist action=drop comment="Bruteforce Blacklist" disabled=yes

## catch 5 failure attempts every 2-minutes
/ip firewall filter
add chain=output action=accept protocol=tcp content="invalid username or password" dst-limit=2/1m,3,dst-address/2m comment="bruteforce-blacklist" disabled=yes
add chain=output action=add-dst-to-address-list protocol=tcp content="invalid username or password" address-list=_bruteforce_blacklist address-list-timeout=5m disabled=yes
