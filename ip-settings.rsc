;; protect your router against ip-spoofing
;; protect your router against DDoS and SYN flood attacks

/ip settings
set rp-filter=strict tcp-syncookies=yes
set rp-filter=strict
