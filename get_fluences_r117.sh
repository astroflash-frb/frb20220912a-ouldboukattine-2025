#!/bin/bash
set -e

##########################
#
# Once we have created all the ar-files (SFXC, scaled, SPC'ed), this
# script is wrapper around .python/ACF_archive.py which lets you compute
# the ACF, the widths, the S/N, the fluences for all burst components. All
# data are stored in a pandas data frame.
#
# Stockert command: ls *.ar | sort -t '/' -k 4 | cut -d '.' -f 1 | cut -c 5- |sed -e 's;^;#"stocke st ;' | sed '$!s/$/ ${sefd_st} B999-st" \\/'
##########################

sefd_o8=310
sefd_wb=420
sefd_wb_p=2100
sefd_tr=250
sefd_st=385

# 512 ms: p11717-wb-06 // pcn023-wb-07 // pcn038-wb-01 // pcn040-wb-10// r67l62-23 (SPC-limited)
# Just note that these are calculated at 512 ms, but the SFXC can be calculated at 128 ms and shown in waterfaller. It's only for fluence.

runs=( \
# exp dish scan sefd ID
#"r67l62 tr 11 L ${sefd_tr} B05-tr V-D-flagged-RFI" \
#"r67l62 tr 15 L ${sefd_tr} B06-tr V-D-flagged-RFI" \
#"r67l62 tr 23 L ${sefd_tr} B07-tr V-D-flagged-512msSPC" \
#"f22l01 tr 28 L ${sefd_tr} B13-tr V-D-256msSPC-flagged" \
#"pcn019 wb 01 L ${sefd_wb} B14-wb V-512ms-faint-tscrunch4" \
#"f22l01 tr 41 L ${sefd_tr} B15-tr V-D-coms" \
#"pcn019 wb 08 L ${sefd_wb} B15-wb V-D" \
#"f22l01 tr 42 L ${sefd_tr} B16-tr V-D" \
#"pcn019-2 wb 08 L ${sefd_wb} B16-wb V-D" \
#"f22l02 tr 28 L ${sefd_tr} B21-tr V-D-flagged-RFI" \
#"pcn021 wb 02 L ${sefd_wb} B22-wb V-D-flagged-RFI" \
#"pcn021 wb 05 L ${sefd_wb} B23-wb V-D-downsample-incalcnodownsample" \
#"f22l03 tr 37 L ${sefd_tr} B23-tr tomuchRFI-scale version-difficult to see" \
#"pcn021 wb 09 L ${sefd_wb} B24-wb V-D-flagged-RFI" \
#"pcn022 wb 01 L ${sefd_wb} B30-wb V-D-flagged-RFI-couldbeimproved" \
#"pcn023 wb 07 L ${sefd_wb} B33-wb V-D-512ms-tscrunch4" \
#"f22l06 tr 03 L ${sefd_tr} B37-tr D-lotsof-RFI" \
#"pcn025 wb 01 L ${sefd_wb} B37-wb V-D" \
#"pcn027 wb 04 L ${sefd_wb} B44-wb V-D" \
#"pcn029 wb 05 L ${sefd_wb} B45-wb V-D" \
#"pcn030 wb 04 L ${sefd_wb} B46-wb V-coms" \
#"pcn037 wb 12 L ${sefd_wb} B51-wb V-D-narrow" \
#"pcn037 wb 15 L ${sefd_wb} B52-wb the-micro-together" \
#"pcn038 wb 01 L ${sefd_wb} B53-wb V-D-narrow" \
#"pcn040 wb 10 L ${sefd_wb} B55-wb D-tscrunch4-remake-the-spc-file-to-128" \
#"p11701 wb 23 L ${sefd_wb} B63-wb V-D" \
#"p11701 wb 31 L ${sefd_wb} B64-wb V-D" \
#"p11702 wb 39 L ${sefd_wb} B66-wb V-D-tscrunch2" \
#"p11703 wb 09 L ${sefd_wb} B68-wb V-D-lots of comp" \
#"p11703 wb 28 L ${sefd_wb} B69-wb V-D-coms-tozap" \
#"p11703 wb 46 L ${sefd_wb} B70-wb V-D-downsample4" \
#"p11704 wb 33 L ${sefd_wb} B71-wb V-D-downsample4" \
#"p11704 wb 40 L ${sefd_wb} B72-wb V-D" \
#"p11708 wb 18 L ${sefd_wb} B81-wb D-veryfaint, maybe tscrunch8? 4-is-doable" \
#"p11708 wb 22 L ${sefd_wb} B82-wb V-D-flagged-RFI" \
#"p11708 wb 27 L ${sefd_wb} B83-wb V-D-flagged-RFI" \
#"p11708 wb 31 L ${sefd_wb} B85-wb V-D-flagged-RFI" \
#"f22l11 tr 28 L ${sefd_tr} B97-tr V-D" \
#"p11715 wb 14 L ${sefd_wb} B101-wb V-D" \
#"p11717 wb 06 L ${sefd_wb} B103-wb V-512ms-very-difficult" \
#"p11717 wb 36 L ${sefd_wb} B104-wb downsample8-very-difficult" \
#"p11717 wb 42 L ${sefd_wb} B105-wb V-D" \
#"p11719 wb 08 L ${sefd_wb} B106-wb V-D-flagged-RFI" \
#"p11719 wb 19 L ${sefd_wb} B107-wb V-D-comp-625KHzchan?" \
#"f22l16 tr 11 L ${sefd_tr} B111-tr V-D-flagged-RFI" \
#"f22l24 tr 27 L ${sefd_tr} B130-tr skipping-Only showing" \
#"f22l46 tr 19 L ${sefd_tr} B132-tr V-D-flagged-RFI" \
##Stockert
#"stocke st 59867_5457019 L ${sefd_st} B01-st V-flagged" \
#"stocke st 59868_7161709 L ${sefd_st} B02-st V-tscrunch2" \
#"stocke st 59868_8024511 L ${sefd_st} B03-st V-neededtohavetscrunch1" \
#"stocke st 59868_8913731 L ${sefd_st} B04-st V" \
#"stocke st 59869_0504865 L ${sefd_st} B07-st V" \
#"stocke st 59869_5823857 L ${sefd_st} B08-st V-comp" \
#"stocke st 59869_5889749 L ${sefd_st} B09-st V-flagged" \
#"stocke st 59869_6732821 L ${sefd_st} B10-st V" \
#"stocke st 59869_6775029 L ${sefd_st} B11-st V" \
#"stocke st 59869_8182693 L ${sefd_st} B12-st V" \
#"stocke st 59869_9461188 L ${sefd_st} B13-st V" \
#"stocke st 59870_3644522 L ${sefd_st} B17-st V" \
#"stocke st 59870_3736731 L ${sefd_st} B18-st V" \
#"stocke st 59870_7739324 L ${sefd_st} B19-st V" \
#"stocke st 59870_9153494 L ${sefd_st} B20-st V-flagged" \
#"stocke st 59872_2649771 L ${sefd_st} B25-st V-tscrunch2" \
#"stocke st 59872_4678143 L ${sefd_st} B26-st V-RFI" \
#"stocke st 59872_4679597 L ${sefd_st} B27-st V-widefit-orstuck-RFI" \
#"stocke st 59872_7005798 L ${sefd_st} B28-st V" \
#"stocke st 59873_5332614 L ${sefd_st} B29-st V" \
#"stocke st 59873_8236494 L ${sefd_st} B30-st V" \
#"stocke st 59874_0936399 L ${sefd_st} B31-st V-cantdoseperatecomp" \
#"stocke st 59874_2154128 L ${sefd_st} B32-st V" \
#"stocke st 59876_6610997 L ${sefd_st} B34-st V" \
#"stocke st 59877_5565197 L ${sefd_st} B35-st V-flagged" \
#"stocke st 59877_5948106 L ${sefd_st} B36-st V" \
#"stocke st 59878_3813848 L ${sefd_st} B38-st V" \
#"stocke st 59878_7374068 L ${sefd_st} B39-st V" \
#"stocke st 59880_3955592 L ${sefd_st} B40-st V-flagged" \
#"stocke st 59880_4029325 L ${sefd_st} B41-st V-flagged" \
#"stocke st 59880_4410798 L ${sefd_st} B42-st V-flagged,still-RFI-left" \
#"stocke st 59880_5668726 L ${sefd_st} B43-st V" \
#"stocke st 59882_6488856 L ${sefd_st} B47-st V" \
#"stocke st 59883_4632665 L ${sefd_st} B48-st V" \
#"stocke st 59883_7188223 L ${sefd_st} B49-st V" \
#"stocke st 59884_4339420 L ${sefd_st} B50-st V-comp" \
#"stocke st 59886_6610037 L ${sefd_st} B53-st V" \
#"stocke st 59888_1332505 L ${sefd_st} B54-st V" \
#"stocke st 59889_5497605 L ${sefd_st} B56-st V" \
#"stocke st 59889_7032667 L ${sefd_st} B57-st V" \
#"stocke st 59889_8204134 L ${sefd_st} B58-st V" \
#"stocke st 59890_2591360 L ${sefd_st} B59-st V-bright!" \
#"stocke st 59890_3176210 L ${sefd_st} B60-st V" \
#"stocke st 59890_3953721 L ${sefd_st} B61-st V" \
#"stocke st 59890_5626041 L ${sefd_st} B62-st V" \
#"stocke st 59891_8065821 L ${sefd_st} B63-st V" \
#"stocke st 59891_8858274 L ${sefd_st} B64-st V" \
#"stocke st 59892_1979510 L ${sefd_st} B65-st V" \
#"stocke st 59893_1379686 L ${sefd_st} B67-st V" \
#"stocke st 59893_6497590 L ${sefd_st} B68-st V" \
#"stocke st 59893_8524570 L ${sefd_st} B69-st V-really-faint-downsample2" \
#"stocke st 59897_4974988 L ${sefd_st} B73-st V" \
#"stocke st 59897_5807878 L ${sefd_st} B74-st V" \
#"stocke st 59897_5915045 L ${sefd_st} B75-st V" \
#"stocke st 59897_6168402 L ${sefd_st} B76-st V" \
#"stocke st 59898_6292376 L ${sefd_st} B77-st V-stupid-bright?" \
#"stocke st 59898_7174280 L ${sefd_st} B78-st V" \
#"stocke st 59898_9401279 L ${sefd_st} B79-st V" \
#"stocke st 59899_5376771 L ${sefd_st} B80-st V" \
#"stocke st 59899_7846540 L ${sefd_st} B82-st V" \
#"stocke st 59899_8813157 L ${sefd_st} B85-st V" \
#"stocke st 59900_1998277 L ${sefd_st} B86-st V" \
#"stocke st 59900_8515123 L ${sefd_st} B87-st V-comp" \
#"stocke st 59901_4075977 L ${sefd_st} B88-st V" \
#"stocke st 59902_0387792 L ${sefd_st} B89-st V" \
#"stocke st 59902_3813459 L ${sefd_st} B90-st V-downsample2-faint-zapped" \
#"stocke st 59902_8121816 L ${sefd_st} B91-st V" \
#"stocke st 59903_0112121 L ${sefd_st} B92-st V" \
#"stocke st 59903_2531485 L ${sefd_st} B93-st V" \
#"stocke st 59903_4752141 L ${sefd_st} B94-st V-flagged" \
#"stocke st 59903_5553178 L ${sefd_st} B95-st V" \
#"stocke st 59903_6046766 L ${sefd_st} B96-st V" \
#"stocke st 59904_2669548 L ${sefd_st} B98-st V" \
#"stocke st 59905_7441603 L ${sefd_st} B99-st V" \
#"stocke st 59908_4923867 L ${sefd_st} B102-st V" \
#"stocke st 59908_8837303 L ${sefd_st} B104-st downsample-4-superfaint" \
#"stocke st 59910_5777429 L ${sefd_st} B106-st V" \
#"stocke st 59910_7022024 L ${sefd_st} B107-st V" \
#"stocke st 59911_6579317 L ${sefd_st} B108-st V" \
#"stocke st 59917_2312582 L ${sefd_st} B112-st V" \
#"stocke st 59917_2650104 L ${sefd_st} B113-st V" \
#"stocke st 59917_5089328 L ${sefd_st} B114-st V-lots-of-RFI" \
#"stocke st 59925_0072834 L ${sefd_st} B116-st V" \
#"stocke st 59949_8819706 L ${sefd_st} B129-st V" \
#"stocke st 59978_5334682 L ${sefd_st} B131-st V" \
#Pband
#"p11714 wb 35 P ${sefd_wb_p} B100-wb t8f2" \
#"p11720 wb 36 P ${sefd_wb_p} B109-wb t8f2" \
#"p11721 wb 46 P ${sefd_wb_p} B110-wb t8f2" \
#"p11730 wb 33 P ${sefd_wb_p} B115-wb t1f1" \
#"p11739 wb 18 P ${sefd_wb_p} B117-wb r2f1" \
#"p11743 wb 43 P ${sefd_wb_p} B118-wb t8f8--very-faint" \
#"p11744 wb 25 P ${sefd_wb_p} B119-wb t2f1" \
#"p11747 wb 20 P ${sefd_wb_p} B120-wb t1f1" \
#"p11747 wb 42 P ${sefd_wb_p} B121-wb t1f1" \
#"p11747 wb 43 P ${sefd_wb_p} B122-wb t8f2--very-faint" \ 
#"p11748 wb 20 P ${sefd_wb_p} B123-wb t8f1--very-faint" \
#"p11748 wb 23 P ${sefd_wb_p} B124-wb t8f1--extremely-faint" \
#"p11748 wb 41 P ${sefd_wb_p} B125-wb t2f1--wide" \
#"p11749 wb 22 P ${sefd_wb_p} B126-wb t2f1" \
#"p11749 wb 26 P ${sefd_wb_p} B127-wb t2f1" \
#"p11749 wb 30 P ${sefd_wb_p} B128-wb t1f1" \
)

basedir=/data1/omar/
dbdir=/home/omar/git/r117-single-dish-analysis/dbs/

#Scrunch is done per burst, depending on visibilty of the burst. 
# for O8, Wb, Tr
Tscrunch=4
Fscrunch=1
# for Stockert, but this is taken care of on the fly
#fscrunch=1
#tscrunch=4
distance=362.4  # Mpc

#db="${dbdir}/burst_info_stk_test.pickle"  # test for playing
srcs=( "sfxc" "scale" "spc" )    # used as tag in the data frame to designate source of the info
compare_to=( " " " " "--compare_to scale" )

ACF_archive=./python/ACF_archive.py

ACF_archive_params="--newfit --distance ${distance} --show_acf_plots"


for run in "${runs[@]}";do
    IFS=" " read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    scan="${info[2]}"
    band="${info[3]}"
    sefd="${info[4]}"
    id="${info[5]}"

    arbase=${exp}_${dish}_no00${scan}

    #Setting DM
    DM_sfxc=0
    if [[ "$band" = "L" ]]; then
        DM_dspsr=219.37
        db="${dbdir}/burst_info_V1.pickle"  # everything goes here
        echo "Setting dspsr DM to $DM_dspsr"
    elif [[ "$band" = "P" ]]; then
        DM_dspsr=219.7
        db="${dbdir}/burst_info_P.pickle"  # everything goes here
        echo "Setting dspsr DM to $DM_dspsr"
    fi
    dms=( ${DM_sfxc} ${DM_dspsr} ${DM_dspsr} )

    #The name of stockert burst will be the MJD of detection
    if [[ ${dish} == 'st' ]];then
        arbase=${exp}_${scan}
    fi

    expbasedir=${basedir}/${exp}
    sfxc_file=${expbasedir}/sfxc/${arbase}.ds.pazi
    scale_file=${expbasedir}/scale_spc/${arbase}_allIFs.vdif_pol2.fil.scale.ds.pazi
    spc_file=${expbasedir}/scale_spc/${arbase}_allIFs.vdif_pol2.fil.scale.spc.ds.pazi
    fs="${sfxc_file} ${scale_file} ${spc_file}"
    fscrunch=${Fscrunch}
    tscrunch=${Tscrunch}
    cnt=0

    for f in ${fs}; do
        if ! [ -e ${f} ];then
            echo "${f} doesn't exist. Moving on..."
            let cnt=${cnt}+1
            continue
        fi
        #db="${dbs[${cnt}]}"
        dm="${dms[${cnt}]}"
        src="${srcs[${cnt}]}"
        comp_to="${compare_to[${cnt}]}"
        if [[ ${dish} == 'st' ]];then
            dm=${DM_dspsr}
            #fscrunch=1
            #tscrunch=1
        fi
        cmd="python3 ${ACF_archive} ${ACF_archive_params} --id ${id} --fscrunch ${fscrunch} --tscrunch ${tscrunch} -d ${dm} --db ${db} --src ${src} -S ${sefd} ${comp_to} ${f}"

        echo "running ${cmd}"
        eval ${cmd}
        let cnt=${cnt}+1
    done
done
