#!/bin/bash

###################
#
# !! First prep, then flag
#
# Before runnning this script you need to:
# - Create the archive files using r117_generate-archive.sh
# - Create the flag files and store them in flags -> but you can base the flag on the spc/scale version, since we will apply the same flag to all 3 files
#
# This script takes the archive-files as generated from the
# coherently dedispersed SFXC-filterbanks and performs the
# following steps:
# - downsample in time to 128 us
# - downsample in freq to ---125-kHz--- 62.5 kHz
# - generate Stokes I
# Command used to generate stockert list
# #ls *.ar | sort -t '/' -k 4 | sed -e 's;^;#"stocke st 01 L 01 ;' | sed '$!s/$/" \\/'

####################

sfxc_dir=/data1/omar/sfxc/r117/fil_to_archives
sfxc_dir_st=/data1/omar/sfxc/r117/fil_to_archives_stockert
outbasedir=/data1/omar/

runs=( \
# exp dish scan sfxc
#"r67014 o8 46 " \
# L-band
#"p11701 wb 23 L p11701_23 p11701_23_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11701 wb 31 L p11701_31 p11701_31_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11702 wb 39 L p11702_39 p11702_39_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11703 wb 09 L p11703_09 p11703_09_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11703 wb 28 L p11703_28 p11703_28_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11703 wb 46 L p11703_46 p11703_46_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11704 wb 33 L p11704_33 p11704_33_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11704 wb 40 L p11704_40 p11704_40_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11708 wb 18 L p11708_18 p11708_18_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11708 wb 22 L p11708_22 p11708_22_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#10
#"p11708 wb 27 L p11708_27 p11708_27_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11708 wb 31 L p11708_31 p11708_31_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11715 wb 14 L p11715_14 p11715_14_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11717 wb 06 L p11717_06 p11717_06_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11717 wb 36 L p11717_36 p11717_36_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11717 wb 42 L p11717_42 p11717_42_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11719 wb 08 L p11719_08 p11719_08_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"p11719 wb 19 L p11719_19 p11719_19_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn019 wb 01 L pcn019_01 pcn019_01_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn019 wb 08 L pcn019_08_1 pcn019_08_1_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#20
#"pcn019-2 wb 08 L pcn019_08_2 pcn019_08_2_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn021 wb 02 L pcn021_02 pcn021_02_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn021 wb 05 L pcn021_05 pcn021_05_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn021 wb 09 L pcn021_09 pcn021_09_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn022 wb 01 L pcn022_01 pcn022_01_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn023 wb 07 L pcn023_07 pcn023_07_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn025 wb 01 L pcn025_01 pcn025_01_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn027 wb 04 L pcn027_04 pcn027_04_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn029 wb 05 L pcn029_05 pcn029_05_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn030 wb 04 L pcn030_04 pcn030_04_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#30
#"pcn037 wb 12 L pcn037_12 pcn037_12_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn037 wb 15 L pcn037_15 pcn037_15_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn038 wb 01 L pcn038_01 pcn038_01_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"pcn040 wb 10 L pcn040_10 pcn040_10_8us_125KHz_StokesI_DM21937_cor_Wb_fil.ar" \
#"r67l62 tr 11 L r67l62_11 r67l62_11_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"r67l62 tr 15 L r67l62_15 r67l62_15_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"r67l62 tr 23 L r67l62_23 r67l62_23_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l01 tr 28 L f22l01_28 f22l01_28_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l01 tr 41 L f22l01_41 f22l01_41_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l01 tr 42 L f22l01_42 f22l01_42_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#40
#"f22l02 tr 28 L f22l02_28 f22l02_28_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l03 tr 37 L f22l03_37 f22l03_37_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l06 tr 03 L f22l06_03 f22l06_03_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l11 tr 28 L f22l11_28 f22l11_28_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l16 tr 11 L f22l16_11 f22l16_11_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l24 tr 27 L f22l24_27 f22l24_27_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"f22l46 tr 19 L f22l46_19 f22l46_19_8us_125KHz_StokesI_DM21937_cor_Tr_fil.ar" \
#"stocke st 01 L 01 snip59867_5457019.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59868_7161709.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59868_8024511.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59868_8913731.a.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59869_0504865.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59869_5823857.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59869_5889749.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59869_6732821.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59869_6775029.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59869_8182693.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59869_9461188.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59870_3644522.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59870_3736731.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59870_7739324.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59870_9153494.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59872_2649771.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59872_4678143.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59872_4679597.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59872_7005798.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59873_5332614.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59873_8236494.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59874_0936399.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59874_2154128.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59876_6610997.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59877_5565197.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59877_5948106.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59878_3813848.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59878_7374068.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59880_3955592.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59880_4029325.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59880_4410798.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59880_5668726.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59882_6488856.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59883_4632665.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59883_7188223.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59884_4339420.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59886_6610037.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59888_1332505.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59889_5497605.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59889_7032667.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59889_8204134.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59890_2591360.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59890_3176210.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59890_3953721.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59890_5626041.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59891_8065821.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59891_8858274.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59892_1979510.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59893_1379686.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59893_6497590.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59893_8524570.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59897_4974988.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59897_5807878.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59897_5915045.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59897_6168402.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59898_6292376.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59898_7174280.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59898_9401279.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59899_5376771.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59899_7846540.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59899_8813157.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59900_1998277.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59900_8515123.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59901_4075977.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59902_0387792.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59902_3813459.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59902_8121816.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59903_0112121.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59903_2531485.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59903_4752141.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59903_5553178.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59903_6046766.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59904_2669548.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59905_7441603.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59908_4923867.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59908_8837303.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59910_5777429.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59910_7022024.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59911_6579317.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59917_2312582.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59917_2650104.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59917_5089328.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59925_0072834.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59949_8819706.fbspi.fil.ar" \
#"stocke st 01 L 01 snip59978_5334682.fbspi.fil.ar" \
#Pband
#"p11714 wb 35 P p11714_35_p p11714_35_256us_31KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11720 wb 36 P p11720_36_p p11720_36_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11721 wb 46 P p11721_46_p p11721_46_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11730 wb 33 P p11730_33_p p11730_33_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11739 wb 18 P p11739_18_p p11739_18_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11743 wb 43 P p11743_43_p p11743_43_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11744 wb 25 P p11744_25_p p11744_25_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11747 wb 20 P p11747_20_p p11747_20_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11747 wb 42 P p11747_42_p p11747_42_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11747 wb 43 P p11747_43_p p11747_43_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11748 wb 20 P p11748_20_p p11748_20_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11748 wb 23 P p11748_23_p p11748_23_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11748 wb 41 P p11748_41_p p11748_41_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11749 wb 22 P p11749_22_p p11749_22_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11749 wb 26 P p11749_26_p p11749_26_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
#"p11749 wb 30 P p11749_30_p p11749_30_256us_32KHz_StokesI_DM2197_cor_Wb_fil.ar" \
)



for run in "${runs[@]}";do

    IFS=" " read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    scan="${info[2]}"
    band="${info[3]}"
    dir_folder="${info[4]}"
    sfxc_ar="${info[5]}"

    target=${sfxc_dir}/${sfxc_ar}    
    linkdir=${outbasedir}/${exp}/sfxc/
    linkname=${exp}_${dish}_no00${scan}.ar

    echo "${target}"
    if [[ "$band" = "L" ]]; then
        tres=128        # in microseconds
        fres=62500     # in Hz
    elif [[ "$band" = "P" ]]; then
        tres=512       # in microseconds
        fres=31250     # in Hz
    fi

    #The name of stockert burst will be the MJD of detection
    if [[ ${dish} == 'st' ]];then
        #echo snip59949_8819706.fbspi.fil.ar | cut -d '.' -f 1 | cut -c 5-
        #return 59949_8819706
        #The name of stockert burst will be the MJD of detection
        mjd_dir=`echo ${sfxc_ar} | cut -d '.' -f 1 | cut -c 5-`
        linkname=${exp}_${mjd_dir}.ar
        
        #Change the location of the archives for stockert bursts
        target=${sfxc_dir_st}/${sfxc_ar}
    fi

    link=${linkdir}/${linkname}
    echo "${link}"
    if [ -e ${link} ];then
        rm ${link}
    fi
    if ! [ -d ${linkdir} ];then
	mkdir -p ${linkdir}
    fi
    ln -s ${target} ${link}
    # use $(( $var )) to remove white spaces around integers
    pars=`psredit -q -Q -c nbin,length,npol,nchan,bw ${link}`
    IFS=" " read -r -a params <<< "${pars}"
    nbin="${params[0]}"
    length="${params[1]}"  # comes in seconds
    npol="${params[2]}"
    nchan="${params[3]}"
    bw="${params[4]}" # in MHz, -ve
    # bash cannot handle floats, so convert bw to an integer in Hz
    bw=`echo "${bw}*1000000" | bc | cut -d '.' -f1`
    if [[ ${bw} -lt 0 ]]; then
        bw=`echo ${bw}*-1 | bc`
    fi
    # convert length to microseconds
    length=`echo "${length}*1000000" | bc`
    time_res=`echo "${length}/${nbin}" | bc`
    freq_res=`echo "${bw}/${nchan}" | bc`
    tscale=`echo "${tres}/${time_res}" | bc`
    fscale=`echo "${fres}/${freq_res}" | bc`
    echo "length=${length}, nbin=${nbin}, npol=${npol}"
    echo "nchan=${nchan}, bw=${bw}"
    echo "time_res=${time_res}, freq_res=${freq_res}"
    echo "tscale=${tscale}, fscale=${fscale}"
    cmd='pam -e ds.ar '
    if [[ ${tscale} -gt 1 ]]; then
        cmd=${cmd}"-b ${tscale} "
    fi
    if [[ ${fscale} -gt 1 ]]; then
        cmd=${cmd}"-f ${fscale} "
    fi
    if [[ ${npol} -gt 1 ]];then
        cmd=${cmd}"-p "
    fi
    cmd=${cmd}${link}
    echo "running ${cmd}"
    #exit 1
    eval ${cmd}
done
