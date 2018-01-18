/queue tree
add comment="----- uploads -----" max-limit=25M name=UPLDQ parent=global priority=1 queue=ethernet-default
add comment="----- low priority -----" limit-at=15M max-limit=25M name=UPLD_BEFF parent=UPLDQ priority=5 queue=ethernet-default
add comment="---- high priority -----" limit-at=3M max-limit=25M name= UPLD_CRIT parent=UPLDQ priority=1 queue=ethernet-default
add name=upld_pr1_crit packet-mark=upld_pr1_crit parent=UPLD_CRIT priority=1 queue=ethernet-default
add name=upld_pr2_crit packet-mark=upld_pr2_crit parent=UPLD_CRIT riority=2 queue=ethernet-default
add name=upld_pr7_crit packet-mark=upld_pr7_crit parent=UPLD_CRIT priority=7 queue=ethernet-default
add name=upld_pr1_beff packet-mark=upld_pr1_beff parent=UPLD_BEFF priority=1 queue=ethernet-default
add name=upld_pr2_beff packet-mark=upld_pr2_beff parent=UPLD_BEFF priority=2 queue=ethernet-default
add name=upld_pr4_beff packet-mark=upld_pr4_beff parent=UPLD_BEFF priority=4 queue=ethernet-default
add name=upld_pr6_beff packet-mark=upld_pr6_beff parent=UPLD_BEFF priority=6 queue=ethernet-default
add name=upld_pr7_beff packet-mark=upld_pr7_beff parent=UPLD_BEFF priority=7 queue=ethernet-default
add name=upld_pr8_beff packet-mark=upld_pr8_beff parent=UPLD_BEFF queue=ethernet-default
add max-limit=6M name=upl_pr8_ratelimited packet-mark=upld_pr8_lmtd parent=UPLD_BEFF queue=ethernet-default
add comment="----- downloads -----" max-limit=25M name=DNLDQ parent=global priority=1 queue=ethernet-default
add comment="----- low priority ----" limit-at=15M max-limit=25M name=DNLD_BEFF parent=DNLDQ priority=5 queue=ethernet-default
add comment="---- high priority ----" limit-at=3M max-limit=25M name=DNLD_CRIT parent=DNLDQ priority=1 queue=ethernet-default
add name=dnld_pr1_crit packet-mark=dnld_pr1_crit parent=DNLD_CRIT priority=1 queue=ethernet-default
add name=dnld_pr2_crit packet-mark=dnld_pr2_crit parent=DNLD_CRIT priority=2 queue=ethernet-default
add name=dnld_pr7_crit packet-mark=dnld_pr7_crit parent=DNLD_CRIT priority=7 queue=ethernet-default
add name=dnld_pr1_beff packet-mark=dnld_pr1_beff parent=DNLD_BEFF priority=1 queue=ethernet-default
add name=dnld_pr2_beff packet-mark=dnld_pr2_beff parent=DNLD_BEFF priority=2 queue=ethernet-default
add name=dnld_pr4_beff packet-mark=dnld_pr4_beff parent=DNLD_BEFF priority=4 queue=ethernet-default
add name=dnld_pr6_beff packet-mark=dnld_pr6_beff parent=DNLD_BEFF priority=6 queue=ethernet-default
add name=dnld_pr7_beff packet-mark=dnld_pr7_beff parent=DNLD_BEFF priority=7 queue=ethernet-default
add name=dnld_pr8_beff packet-mark=dnld_pr8_beff parent=DNLD_BEFF queue=ethernet-default
add max-limit=6M name=dnld_pr8_lmtd packet-mark=dnld_pr8_lmtd parent=DNLD_BEFF queue=ethernet-default
