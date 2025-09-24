#!/bin/bash

#####################
#
# This script takes the flag files 
# into the git repo and applies them to the scaled, SPC'ed, and SFXC archives with 'paz'.
#
# For stockert we automatically make a zap file with 0 and 168; if that is not enough I used paz to zap the channels manually and add them to the flag file
#
# Once all the flags are applied, we can start to compute fluences, S/N, widths, TOAs...
#
# Command for stockert list
# ls *.ar | sort -t '/' -k 4 | cut -d '.' -f 1 | cut -c 5- |sed -e 's;^;#"stocke st ;' | sed '$!s/$/" \\/'
# First prep, then flag
####################


pwait() {
    while [ $(jobs -p | wc -l) -ge $1 ]; do
	sleep 0.33
    done
}
njobs=16

outbasedir=/data1/omar/
flagrundir=/home/omar/git/r117-single-dish-analysis/flags/

runs=( \
# exp dish scan flag
#"p11701 wb 23 L" \
#"p11701 wb 31 L" \
#"p11702 wb 39 L" \
#"p11703 wb 09 L" \
#"p11703 wb 28 L" \
#"p11703 wb 46 L" \
#"p11704 wb 33 L" \
#"p11704 wb 40 L" \
#"p11708 wb 18 L" \
#"p11708 wb 22 L" \
#"p11708 wb 27 L" \
#
#"p11708 wb 31 L" \
#"p11715 wb 14 L" \
#"p11717 wb 06 L" \
#"p11717 wb 36 L" \
#"p11717 wb 42 L" \
#"p11719 wb 08 L" \
#"p11719 wb 19 L" \
#"pcn019 wb 01 L" \
#"pcn019 wb 08 L" \
#20
#"pcn019-2 wb 08 L" \
#"pcn021 wb 02 L" \
#"pcn021 wb 05 L" \
#"pcn021 wb 09 L" \
#"pcn022 wb 01 L" \
#"pcn023 wb 07 L" \
#"pcn025 wb 01 L" \
#"pcn027 wb 04 L" \
#"pcn029 wb 05 L" \
#"pcn030 wb 04 L" \
#30
#"pcn037 wb 12 L" \
#"pcn037 wb 15 L" \
#"pcn038 wb 01 L" \
#"pcn040 wb 10 L" \
#"r67l62 tr 11 L" \
#"r67l62 tr 15 L" \
#"r67l62 tr 23 L" \
#"f22l01 tr 28 L" \
#"f22l01 tr 41 L" \
#"f22l01 tr 42 L" \
#40
#"f22l02 tr 28 L" \
#"f22l03 tr 37 L" \
#"f22l06 tr 03 L" \
#"f22l11 tr 28 L" \
#"f22l16 tr 11 L" \
#"f22l24 tr 27 L" \
#"f22l46 tr 19 L" \
#"stocke st 59867_5457019 L reflagged" \
#"stocke st 59868_7161709 L" \
#"stocke st 59868_8024511 L" \
#"stocke st 59868_8913731 L" \
#"stocke st 59869_0504865 L" \
#"stocke st 59869_5823857 L" \
#"stocke st 59869_5889749 L reflagged" \
#"stocke st 59869_6732821 L" \
#"stocke st 59869_6775029 L" \
#"stocke st 59869_8182693 L" \
#"stocke st 59869_9461188 L" \
#"stocke st 59870_3644522 L" \
#"stocke st 59870_3736731 L" \
#"stocke st 59870_7739324 L" \
#"stocke st 59870_9153494 L reflagged" \
#"stocke st 59872_2649771 L" \
#"stocke st 59872_4678143 L reflagged" \
#"stocke st 59872_4679597 L reflagged" \
#"stocke st 59872_7005798 L" \
#"stocke st 59873_5332614 L" \
#"stocke st 59873_8236494 L" \
#"stocke st 59874_0936399 L" \
#"stocke st 59874_2154128 L" \
#"stocke st 59876_6610997 L" \
#"stocke st 59877_5565197 L reflagged" \
#"stocke st 59877_5948106 L" \
#"stocke st 59878_3813848 L" \
#"stocke st 59878_7374068 L" \
#"stocke st 59880_3955592 L reflagged" \
#"stocke st 59880_4029325 L reflagged" \
#"stocke st 59880_4410798 L reflagged" \
#"stocke st 59880_5668726 L" \
#"stocke st 59882_6488856 L" \
#"stocke st 59883_4632665 L" \
#"stocke st 59883_7188223 L" \
#"stocke st 59884_4339420 L" \
#"stocke st 59886_6610037 L" \
#"stocke st 59888_1332505 L" \
#"stocke st 59889_5497605 L" \
#"stocke st 59889_7032667 L" \
#"stocke st 59889_8204134 L" \
#"stocke st 59890_2591360 L" \
#"stocke st 59890_3176210 L" \
#"stocke st 59890_3953721 L" \
#"stocke st 59890_5626041 L" \
#"stocke st 59891_8065821 L" \
#"stocke st 59891_8858274 L" \
#"stocke st 59892_1979510 L" \
#"stocke st 59893_1379686 L" \
#"stocke st 59893_6497590 L" \
#"stocke st 59893_8524570 L" \
#"stocke st 59897_4974988 L" \
#"stocke st 59897_5807878 L" \
#"stocke st 59897_5915045 L" \
#"stocke st 59897_6168402 L" \
#"stocke st 59898_6292376 L" \
#"stocke st 59898_7174280 L" \
#"stocke st 59898_9401279 L" \
#"stocke st 59899_5376771 L" \
#"stocke st 59899_7846540 L" \
#"stocke st 59899_8813157 L" \
#"stocke st 59900_1998277 L" \
#"stocke st 59900_8515123 L" \
#"stocke st 59901_4075977 L" \
#"stocke st 59902_0387792 L" \
#"stocke st 59902_3813459 L reflagged" \
#"stocke st 59902_8121816 L" \
#"stocke st 59903_0112121 L" \
#"stocke st 59903_2531485 L" \
#"stocke st 59903_4752141 L reflagged" \
#"stocke st 59903_5553178 L" \
#"stocke st 59903_6046766 L" \
#"stocke st 59904_2669548 L" \
#"stocke st 59905_7441603 L" \
#"stocke st 59908_4923867 L reflagged" \
#"stocke st 59908_8837303 L" \
#"stocke st 59910_5777429 L" \
#"stocke st 59910_7022024 L reflagged" \
#"stocke st 59911_6579317 L reflagged" \
#"stocke st 59917_2312582 L reflagged" \
#"stocke st 59917_2650104 L" \
#"stocke st 59917_5089328 L reflagged, lots of rfi" \
#"stocke st 59925_0072834 L" \
#"stocke st 59949_8819706 L" \
#"stocke st 59978_5334682 L" \
#Pband
#"p11749 wb 30 P" \
#"p11714 wb 35 P" \
#"p11720 wb 36 P " \
#"p11721 wb 46 P" \
#"p11730 wb 33 P" \
#"p11739 wb 18 P" \
#"p11743 wb 43 P" \
#"p11744 wb 25 P" \
#"p11747 wb 20 P " \
#"p11747 wb 42 P" \
#"p11747 wb 43 P" \
#"p11748 wb 20 P" \
#"p11748 wb 23 P " \
#"p11748 wb 41 P" \
#"p11749 wb 22 P" \
#"p11749 wb 26 P" \
#"p11749 wb 30 P" \
)

for run in "${runs[@]}";do
    IFS=" " read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    scan="${info[2]}"
    band="${info[3]}"
    arbase=${exp}_${dish}_no00${scan}
    flagfile=${arbase}.sh
    echo ${flagfile}

    #The name of stockert burst will be the MJD of detection
    if [[ ${dish} == 'st' ]];then
        arbase=${exp}_${scan}
    fi

    expbasedir=${outbasedir}/${exp}
    if [ "$dish" = "st" ] && ! [ -e ${flagrundir}/${flagfile} ]; then
        # this is for Stockert only.
        echo -e '#!/bin/bash\npaz -e pazi -z "0 167" $1' > ${flagrundir}/${flagfile}
        echo "created ${expbasedir}/${flagfile} containing"
        cat ${flagrundir}/${flagfile}
    fi

    #In case there is no flag file; automatically make one containing the subband edges
    if [ "$band" = "P" ] && ! [ -e ${flagrundir}/${flagfile} ]; then
        echo -e '#!/bin/bash\npaz -e pazi -z "0,1,254,255,256,257,510,511,512,513,766,767,768,769,1022,1023,1024,1025,1278,1279,1280,1281,1534,1535,1536,1537,1790,1791" $1' > ${flagrundir}/${flagfile}
        echo "created ${expbasedir}/${flagfile} containing"
        cat ${flagrundir}/${flagfile}
    fi

    chmod u+x ${flagrundir}/${flagfile}
    sfxc_file=${expbasedir}/sfxc/${arbase}.ds.ar
    scale_file=${expbasedir}/scale_spc/${arbase}_allIFs.vdif_pol2.fil.scale.ds.ar
    spc_file=${expbasedir}/scale_spc/${arbase}_allIFs.vdif_pol2.fil.scale.spc.ds.ar
    #fs="${scale_file} ${spc_file}"
    fs="${sfxc_file} ${scale_file} ${spc_file}"
    for f in ${fs}; do
        if ! [ -e ${f} ];then
            echo "${f} doesn't exist. Moving on..."
            continue
        fi
        cmd="${flagrundir}/${flagfile} ${f}"
        echo "running ${cmd}"
        eval ${cmd}
    done
done

#pazi command:
#When creating the archives files I had to zap channels otherwise the bursts were not visible. First I let this script create the .sh files, then added these channels to that file to zap the bad channels
# p11739_wb_no0018.ds.pazi paz -z "521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 540 541 542 543 544 545 546 547 548 549 550 551 552 553 554 555 556 557 558 559 560 561 562 563 564 565 566 567 568 569 570 571 572 573 574 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 590 591 894 895 896 897" -e pazi p11739_wb_no0018.ds.pazi
#paz -z "886 887 888 889 497 498 415 416" -e pazi p11748_wb_no0020_allIFs.vdif_pol2.fil.scale.ds.ar
#513 514 515 516 517 518 519 520 521 522 41 42 43 44" -e pazi p11739_wb_no0018_allIFs.vdif_pol2.fil.scale.ds.pazi

######
#snip59870.7739324 -- paz -z "143 144 145 146 147 141 142 148 149 140 150 151 101 102 103 139" 
#snip59874.0936399 -- paz -z "92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138" 
#snip59876.6610997 -- paz -z "134 135 136 137 138 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133"
#snip59878.3813848 -- paz -z "135 136 137 138 132 133 134 108 109 110 111 94 95 96 97 126 115 116 117 100 124 125 123 105 106 130 131 98 99"
#snip59883.7188223 -- paz -z "135 136 137 138 131 132 133 134 130 104 105 106 107 94 95 96 97 98 99 100 101 108 109 110 111 112 113 114 115 116 117 102 103 127 128 129 122 123 125 126 118 119 120 121"
#snip59889.7032667 -- paz -z "135 136 137 138 129 130 131 125 126 127 128 114 115 116 117 105 106 107 94 95 96 102 103 118 119 120 132 133 112 113 98 99 101 108 122 123"
#snip59897.4974988 -- paz -z "97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 52 53 54 55 56 69 70 71 72 73 74 75 135 136 137 133 134 123 124 125 126 127 128 122 131 132"
#snip59899.8813157 -- paz -z "97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 95 96"
#snip59903_2531485 -- paz -z "94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138"
