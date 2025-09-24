#!/bin/bash
set -e

###############
#
# This script takes the SFXC-generated, coherently dedispersed filterbanks
# and downsamples them to the same time and frequency resolution as what the
# digifil-generated filterbanks have. It then puts the files in the right
# directories.
#
# These filterbanks were used to determine the TOAs of the bursts.
#
# Generate St  command: ls *.fil | sort -t '/' -k 4 | sed -e 's;^;#"stocke st 01 01 ;' | sed '$!s/$/" \\/'
###############

sfxc_dir=/data1/omar/sfxc/r117/
outbasedir=/data1/omar/

runs=( \
# exp  dish scan dir filterbank
"p11701 wb L 23 p11701_23 p11701_23_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11701 wb L 31 p11701_31 p11701_31_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11702 wb L 39 p11702_39 p11702_39_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11703 wb L 09 p11703_09 p11703_09_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11703 wb L 28 p11703_28 p11703_28_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11703 wb L 46 p11703_46 p11703_46_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11704 wb L 33 p11704_33 p11704_33_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11704 wb L 40 p11704_40 p11704_40_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11708 wb L 18 p11708_18 p11708_18_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11708 wb L 22 p11708_22 p11708_22_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11708 wb L 27 p11708_27 p11708_27_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11708 wb L 31 p11708_31 p11708_31_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11715 wb L 14 p11715_14 p11715_14_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11717 wb L 06 p11717_06 p11717_06_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11717 wb L 36 p11717_36 p11717_36_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11717 wb L 42 p11717_42 p11717_42_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11719 wb L 08 p11719_08 p11719_08_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"p11719 wb L 19 p11719_19 p11719_19_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn019 wb L 01 pcn019_01 pcn019_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn019 wb L 08 pcn019_08_1 pcn019_08_1_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn019-2 wb L 08 pcn019_08_2 pcn019_08_2_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn021 wb L 02 pcn021_02 pcn021_02_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn021 wb L 05 pcn021_05 pcn021_05_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn021 wb L 09 pcn021_09 pcn021_09_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn022 wb L 01 pcn022_01 pcn022_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn023 wb L 07 pcn023_07 pcn023_07_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn025 wb L 01 pcn025_01 pcn025_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn027 wb L 04 pcn027_04 pcn027_04_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn029 wb L 05 pcn029_05 pcn029_05_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn030 wb L 04 pcn030_04 pcn030_04_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn037 wb L 12 pcn037_12 pcn037_12_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn037 wb L 15 pcn037_15 pcn037_15_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn038 wb L 01 pcn038_01 pcn038_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"pcn040 wb L 10 pcn040_10 pcn040_10_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
"r67l62 tr L 11 r67l62_11 r67l62_11_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"r67l62 tr L 15 r67l62_15 r67l62_15_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"r67l62 tr L 23 r67l62_23 r67l62_23_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l01 tr L 28 f22l01_28 f22l01_28_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l01 tr L 41 f22l01_41 f22l01_41_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l01 tr L 42 f22l01_42 f22l01_42_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l02 tr L 28 f22l02_28 f22l02_28_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l03 tr L 37 f22l03_37 f22l03_37_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l06 tr L 03 f22l06_03 f22l06_03_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l11 tr L 28 f22l11_28 f22l11_28_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l16 tr L 11 f22l16_11 f22l16_11_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l24 tr L 27 f22l24_27 f22l24_27_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
"f22l46 tr L 19 f22l46_19 f22l46_19_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \

#Pband
#"p11714 wb P 35 p11714_35_p p11714_35_256us_31KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11720 wb P 36 p11720_36_p p11720_36_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11721 wb P 46 p11721_46_p p11721_46_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11730 wb P 33 p11730_33_p p11730_33_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11739 wb P 18 p11739_18_p p11739_18_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11743 wb P 43 p11743_43_p p11743_43_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11744 wb P 25 p11744_25_p p11744_25_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11747 wb P 20 p11747_20_p p11747_20_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11747 wb P 42 p11747_42_p p11747_42_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11747 wb P 43 p11747_43_p p11747_43_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11748 wb P 20 p11748_20_p p11748_20_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11748 wb P 23 p11748_23_p p11748_23_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11748 wb P 41 p11748_41_p p11748_41_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11749 wb P 22 p11749_22_p p11749_22_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11749 wb P 26 p11749_26_p p11749_26_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \
#"p11749 wb P 30 p11749_30_p p11749_30_256us_32KHz_StokesI_DM2197_cor_Wb.fil" \

#Run 29-Jun-2023 
#"stocke st L 01 01 snip59867.5457019.fbspi.fil" \
#"stocke st L 01 01 snip59867.5457019.fbspi.fil" \
#"stocke st L 01 01 snip59868.7161709.fbspi.fil" \
#"stocke st L 01 01 snip59868.8024511.fbspi.fil" \
#"stocke st L 01 01 snip59868.8913731.a.fbspi.fil" \
#"stocke st L 01 01 snip59868.8913731.fbspi.fil" \
#"stocke st L 01 01 snip59869.0504865.fbspi.fil" \
#"stocke st L 01 01 snip59869.5823857.fbspi.fil" \
#"stocke st L 01 01 snip59869.5889749.fbspi.fil" \
#"stocke st L 01 01 snip59869.6732821.fbspi.fil" \
#"stocke st L 01 01 snip59869.6775029.fbspi.fil" \
#"stocke st L 01 01 snip59869.8182693.fbspi.fil" \
#"stocke st L 01 01 snip59869.9461188.fbspi.fil" \
#"stocke st L 01 01 snip59870.3644522.fbspi.fil" \
#"stocke st L 01 01 snip59870.3736731.fbspi.fil" \
#"stocke st L 01 01 snip59870.7739324.fbspi.fil" \
#"stocke st L 01 01 snip59870.9153494.fbspi.fil" \
#"stocke st L 01 01 snip59872.2649771.fbspi.fil" \
#"stocke st L 01 01 snip59872.4678143.fbspi.fil" \
#"stocke st L 01 01 snip59872.4679597.fbspi.fil" \
#"stocke st L 01 01 snip59872.7005798.fbspi.fil" \
#"stocke st L 01 01 snip59873.5332614.fbspi.fil" \
#"stocke st L 01 01 snip59873.8236494.fbspi.fil" \
#"stocke st L 01 01 snip59874.0936399.fbspi.fil" \
#"stocke st L 01 01 snip59874.2154128.fbspi.fil" \
#"stocke st L 01 01 snip59876.6610997.fbspi.fil" \
#"stocke st L 01 01 snip59877.5565197.fbspi.fil" \
#"stocke st L 01 01 snip59877.5948106.fbspi.fil" \
#"stocke st L 01 01 snip59878.3813848.fbspi.fil" \
#"stocke st L 01 01 snip59878.7374068.fbspi.fil" \
#"stocke st L 01 01 snip59880.3955592.fbspi.fil" \
#"stocke st L 01 01 snip59880.4029325.fbspi.fil" \
#"stocke st L 01 01 snip59880.4410798.fbspi.fil" \
#"stocke st L 01 01 snip59880.5668726.fbspi.fil" \
#"stocke st L 01 01 snip59882.6488856.fbspi.fil" \
#"stocke st L 01 01 snip59883.4632665.fbspi.fil" \
#"stocke st L 01 01 snip59883.7188223.fbspi.fil" \
#"stocke st L 01 01 snip59884.4339420.fbspi.fil" \
#"stocke st L 01 01 snip59886.6610037.fbspi.fil" \
#"stocke st L 01 01 snip59888.1332505.fbspi.fil" \
#"stocke st L 01 01 snip59889.5497605.fbspi.fil" \
#"stocke st L 01 01 snip59889.7032667.fbspi.fil" \
#"stocke st L 01 01 snip59889.8204134.fbspi.fil" \
#"stocke st L 01 01 snip59890.2591360.fbspi.fil" \
#"stocke st L 01 01 snip59890.3176210.fbspi.fil" \
#"stocke st L 01 01 snip59890.3953721.fbspi.fil" \
#"stocke st L 01 01 snip59890.5626041.fbspi.fil" \
#"stocke st L 01 01 snip59891.8065821.fbspi.fil" \
#"stocke st L 01 01 snip59891.8858274.fbspi.fil" \
#"stocke st L 01 01 snip59892.1979510.fbspi.fil" \
#"stocke st L 01 01 snip59893.1379686.fbspi.fil" \
#"stocke st L 01 01 snip59893.6497590.fbspi.fil" \
#"stocke st L 01 01 snip59893.8524570.fbspi.fil" \
#"stocke st L 01 01 snip59897.4974988.fbspi.fil" \
#"stocke st L 01 01 snip59897.5807878.fbspi.fil" \
#"stocke st L 01 01 snip59897.5915045.fbspi.fil" \
#"stocke st L 01 01 snip59897.6168402.fbspi.fil" \
#"stocke st L 01 01 snip59898.6292376.fbspi.fil" \
#"stocke st L 01 01 snip59898.7174280.fbspi.fil" \
#"stocke st L 01 01 snip59898.9401279.fbspi.fil" \
#"stocke st L 01 01 snip59899.5376771.fbspi.fil" \
#"stocke st L 01 01 snip59899.7846540.fbspi.fil" \
#"stocke st L 01 01 snip59899.8813157.fbspi.fil" \
#"stocke st L 01 01 snip59900.1998277.fbspi.fil" \
#"stocke st L 01 01 snip59900.8515123.fbspi.fil" \
#"stocke st L 01 01 snip59901.4075977.fbspi.fil" \
#"stocke st L 01 01 snip59902.0387792.fbspi.fil" \
#"stocke st L 01 01 snip59902.3813459.fbspi.fil" \
#"stocke st L 01 01 snip59902.8121816.fbspi.fil" \
#"stocke st L 01 01 snip59903.0112121.fbspi.fil" \
#"stocke st L 01 01 snip59903.2531485.fbspi.fil" \
#"stocke st L 01 01 snip59903.4752141.fbspi.fil" \
#"stocke st L 01 01 snip59903.5553178.fbspi.fil" \
#"stocke st L 01 01 snip59903.6046766.fbspi.fil" \
#"stocke st L 01 01 snip59904.2669548.fbspi.fil" \
#"stocke st L 01 01 snip59905.7441603.fbspi.fil" \
#"stocke st L 01 01 snip59908.4923867.fbspi.fil" \
#"stocke st L 01 01 snip59908.8837303.fbspi.fil" \
#"stocke st L 01 01 snip59910.5777429.fbspi.fil" \
#"stocke st L 01 01 snip59910.7022024.fbspi.fil" \
#"stocke st L 01 01 snip59911.6579317.fbspi.fil" \
#"stocke st L 01 01 snip59917.2312582.fbspi.fil" \
#"stocke st L 01 01 snip59917.2650104.fbspi.fil" \
#"stocke st L 01 01 snip59917.5089328.fbspi.fil" \
#"stocke st L 01 01 snip59925.0072834.fbspi.fil" \
#"stocke st L 01 01 snip59949.8819706.fbspi.fil" \
#"stocke st L 01 01 snip59978.5334682.fbspi.fil" \
)

for run in "${runs[@]}";do
    IFS=" " read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    band="${info[2]}"
    scan="${info[3]}"
    dir="${info[4]}"
    sfxc_fil="${info[5]}"
    fulldir=${sfxc_dir}/${dir}
    if [[ ${dish} == 'st' ]];then
        fulldir=/scratch2/omar/burst-detections/r117/stockert-detections/r117-stk-burst
    fi
    target=${fulldir}/${sfxc_fil}
    if ! [[ -e ${target} ]];then
        echo "cannot find ${target}"
    fi

    #Settings of output filterbanks
    if [[ "$band" = "L" ]]; then
    ##Lband
    #This setting also works for Stockert, since it won't actually downsample
        tres_out=64         # in microseconds
        fres_out=125000     # in Hz
    elif [[ "$band" = "P" ]]; then
        tres_out=512       # in microseconds
        fres_out=31250     # in Hz
    fi

    #The name of stockert burst will be the MJD of detection
    if [[ ${dish} == 'st' ]];then
        #The name of stockert burst will be the MJD of detection
        #snip59867.5457019.fbspi.fil
        #snip59867_5457019.fbspi.fil -- replace the first dot
        sfxc_fil_d=${sfxc_fil/./_}

        #echo snip59949_8819706.fbspi.fil | cut -d '.' -f 1 | cut -c 5-
        #return 59949_8819706
        mjd_dir=`echo ${sfxc_fil_d} | cut -d '.' -f 1 | cut -c 5-`
        linkname=${exp}_${mjd_dir}.fil
    else
        linkname=${exp}_${dish}_no00${scan}.fil
    fi

    linkdir=${outbasedir}/${exp}/sfxc/
    link=${linkdir}/${linkname}

    if [ -e ${link} ];then
        rm ${link}
    fi
    if ! [ -d ${linkdir} ];then
        mkdir -p ${linkdir}
    fi
    cmd="ln -s ${target} ${link}"
    echo "running ${cmd}"
    eval ${cmd}

    ##
    #pars=`header ${link} -tsamp -nifs -foff -nbits`
    #echo ${pars}
    #IFS=" " read -r -a params <<< "${pars}"
    tres_in=`header ${link} -tsamp`   # in microseconds
    npol=`header ${link} -nifs`    # 4 for full pol, we want Stokes I
    fres_in=`header ${link} -foff`
    nbits=`header ${link} -nbits`
    if [[ ${nbits} == '32' ]];then
        nbits='-32'
    fi
    ## bash cannot handle floats, so convert fres_in to an integer in Hz
    fres_in=`echo "${fres_in}*1000000" | bc | cut -d '.' -f1`
    if [[ ${fres_in} -lt 0 ]]; then
        fres_in=`echo ${fres_in}*-1 | bc`
    fi
    ## get the scrunching factors
    tscale=`echo "${tres_out}/${tres_in}" | bc`
    fscale=`echo "${fres_out}/${fres_in}" | bc`
    echo "tres_in=${tres_in}, fres_in=${fres_in}"
    echo "tscale=${tscale}, fscale=${fscale}"
    cmd="digifil ${link} -o ${link%fil}ds.fil -I0 -b ${nbits} "
    if [[ ${tscale} -gt 1 ]]; then
        cmd=${cmd}"-t ${tscale} "
    fi
    if [[ ${fscale} -gt 1 ]]; then
        cmd=${cmd}"-f ${fscale} "
    fi
    if [[ ${npol} -gt 1 ]];then
        cmd=${cmd}"-d1 "
    fi
    echo "running ${cmd}"
    ##exit 1
    eval ${cmd}
done
