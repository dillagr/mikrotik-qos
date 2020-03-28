/queue tree
add comment="----- uploads -----" max-limit=25M name=UPLDQ parent=global priority=1 queue=ethernet-default
add comment="----- best effort -----" limit-at=15M max-limit=25M name=UPLD_BEFF parent=UPLDQ priority=5 queue=ethernet-default
add comment="---- critical -----" limit-at=3M max-limit=25M name= UPLD_CRIT parent=UPLDQ priority=1 queue=ethernet-default
add name=W1UPPR1_CRIT packet-mark=W1UPPR1_CRIT parent=UPLD_CRIT priority=1 queue=ethernet-default
add name=W1UPPR2_CRIT packet-mark=W1UPPR2_CRIT parent=UPLD_CRIT riority=2 queue=ethernet-default
add name=W1UPPR7_CRIT packet-mark=W1UPPR7_CRIT parent=UPLD_CRIT priority=7 queue=ethernet-default
add name=W1UPPR1_BEFF packet-mark=W1UPPR1_BEFF parent=UPLD_BEFF priority=1 queue=ethernet-default
add name=W1UPPR2_BEFF packet-mark=W1UPPR2_BEFF parent=UPLD_BEFF priority=2 queue=ethernet-default
add name=W1UPPR4_BEFF packet-mark=W1UPPR4_BEFF parent=UPLD_BEFF priority=4 queue=ethernet-default
add name=W1UPPR6_BEFF packet-mark=W1UPPR6_BEFF parent=UPLD_BEFF priority=6 queue=ethernet-default
add name=W1UPPR7_BEFF packet-mark=W1UPPR7_BEFF parent=UPLD_BEFF priority=7 queue=ethernet-default
add name=W1UPPR8_BEFF packet-mark=W1UPPR8_BEFF parent=UPLD_BEFF queue=ethernet-default
add max-limit=6M name=W1UPPR8_LMTD packet-mark=W1UPPR8_LMTD parent=UPLD_BEFF queue=ethernet-default
add comment="----- downloads -----" max-limit=25M name=DNLDQ parent=global priority=1 queue=ethernet-default
add comment="----- best effort ----" limit-at=15M max-limit=25M name=DNLD_BEFF parent=DNLDQ priority=5 queue=ethernet-default
add comment="---- critical ----" limit-at=3M max-limit=25M name=DNLD_CRIT parent=DNLDQ priority=1 queue=ethernet-default
add name=W1DNPR1_CRIT packet-mark=W1DNPR1_CRIT parent=DNLD_CRIT priority=1 queue=ethernet-default
add name=W1DNPR2_CRIT packet-mark=W1DNPR2_CRIT parent=DNLD_CRIT priority=2 queue=ethernet-default
add name=W1DNPR7_CRIT packet-mark=W1DNPR7_CRIT parent=DNLD_CRIT priority=7 queue=ethernet-default
add name=W1DNPR1_BEFF packet-mark=W1DNPR1_BEFF parent=DNLD_BEFF priority=1 queue=ethernet-default
add name=W1DNPR2_BEFF packet-mark=W1DNPR2_BEFF parent=DNLD_BEFF priority=2 queue=ethernet-default
add name=W1DNPR4_BEFF packet-mark=W1DNPR4_BEFF parent=DNLD_BEFF priority=4 queue=ethernet-default
add name=W1DNPR6_BEFF packet-mark=W1DNPR6_BEFF parent=DNLD_BEFF priority=6 queue=ethernet-default
add name=W1DNPR7_BEFF packet-mark=W1DNPR7_BEFF parent=DNLD_BEFF priority=7 queue=ethernet-default
add name=W1DNPR8_BEFF packet-mark=W1DNPR8_BEFF parent=DNLD_BEFF queue=ethernet-default
add max-limit=6M name=W1DNPR8_LMTD packet-mark=W1DNPR8_LMTD parent=DNLD_BEFF queue=ethernet-default
