#!/bin/bash
set -e

##############
#
# This is a wrapper around ./python/get_MJD.py which
# combines the info from the ar-files and the pandas data
# frames to fit the bursts in the SFXC/Stockert-filterbanks with
# Guassians to determine the TOAs. For SFXC-filterbanks these
# are geocentric TOAs, while for Stockert they are topocentric at Stockert.
#
# First use prep_sfxc_filterbank to prepare the symlinks for the filterbank files
# The archive files are needed to copy the masks from the archive onto the filterbank files
#############

## References frequencies
#Middle of top subband for EVN dishes and SFXC filterbanks 
#Pband (setup P - 356-4 MHz) - SFXC 
ref_freq_wb_p=352

#Wb L-band (setup L18 - 1335-8 MHz) - SFXC 
ref_freq_wb_1g=1327

#Tr L-band (setup L15 - 1478-8)
ref_freq_tr_1g=1470.0
 
#St L-band (script will read the header file of the filterbank and take the Highchannel as ref freq)
ref_freq_st_1g='none'

fscrunch=1
tscrunch=1

# exp dish scan sefd ID ref_freq DM
runs=( \
#EVN dishes L-band
#Main time- and freq- resolution: 64 us and 125 Khz
#"r67l62 tr 11 coe B05-tr ${ref_freq_tr_1g} 0.0 t2 V" \
#"r67l62 tr 15 coe B06-tr ${ref_freq_tr_1g} 0.0 t2 V" \
#"r67l62 tr 23 coe B07-tr ${ref_freq_tr_1g} 0.0 V" \
#"f22l01 tr 28 coe B13-tr ${ref_freq_tr_1g} 0.0 V" \
#"pcn019 wb 01 coe B14-wb ${ref_freq_wb_1g} 0.0 t8 V" \
#5
#"f22l01 tr 41 coe B15-tr ${ref_freq_tr_1g} 0.0 V" \
#"pcn019 wb 08 coe B15-wb ${ref_freq_wb_1g} 0.0 V" \
#"f22l01 tr 42 coe B16-tr ${ref_freq_tr_1g} 0.0 V" \
#"pcn019-2 wb 08 coe B16-wb ${ref_freq_wb_1g} 0.0 V" \
#"f22l02 tr 28 coe B21-tr ${ref_freq_tr_1g} 0.0 V" \
#10
#"pcn021 wb 02 coe B22-wb ${ref_freq_wb_1g} 0.0 V" \
#"pcn021 wb 05 coe B23-wb ${ref_freq_wb_1g} 0.0 t4 V" \
#"f22l03 tr 37 coe B23-tr ${ref_freq_tr_1g} 0.0 something wrong?" \
#"pcn021 wb 09 coe B24-wb ${ref_freq_wb_1g} 0.0 V" \
#"pcn022 wb 01 coe B30-wb ${ref_freq_wb_1g} 0.0 V" \
#15
#"pcn023 wb 07 coe B33-wb ${ref_freq_wb_1g} 0.0 t4 V" \
#"f22l06 tr 03 coe B37-tr ${ref_freq_tr_1g} 0.0 V" \
#"pcn025 wb 01 coe B37-wb ${ref_freq_wb_1g} 0.0 V" \
#"pcn027 wb 04 coe B44-wb ${ref_freq_wb_1g} 0.0 V" \
#"pcn029 wb 05 coe B45-wb ${ref_freq_wb_1g} 0.0 V" \
#20
#"pcn030 wb 04 coe B46-wb ${ref_freq_wb_1g} 0.0 V-maybe4comp?" \
#"pcn037 wb 12 coe B51-wb ${ref_freq_wb_1g} 0.0 V" \
#"pcn037 wb 15 coe B52-wb ${ref_freq_wb_1g} 0.0 V-4comp-micro-together" \
#"pcn038 wb 01 coe B53-wb ${ref_freq_wb_1g} 0.0 V" \
#"pcn040 wb 10 coe B55-wb ${ref_freq_wb_1g} 0.0 t8 V" \
#25
#"p11701 wb 31 coe B64-wb ${ref_freq_wb_1g} 0.0 V" \
#"p11702 wb 39 coe B66-wb ${ref_freq_wb_1g} 0.0 V" \
#"p11703 wb 09 coe B68-wb ${ref_freq_wb_1g} 0.0 V-possibly more than 4 comp" \
#"p11703 wb 28 coe B69-wb ${ref_freq_wb_1g} 0.0 V" \
#"p11703 wb 46 coe B70-wb ${ref_freq_wb_1g} 0.0 t8 V" \
#30
#"p11704 wb 33 coe B71-wb ${ref_freq_wb_1g} 0.0 t8 V" \
#"p11704 wb 40 coe B72-wb ${ref_freq_wb_1g} 0.0 t4 V" \
#"p11708 wb 18 coe B81-wb ${ref_freq_wb_1g} 0.0 t8 V" \
#"p11708 wb 22 coe B82-wb ${ref_freq_wb_1g} 0.0 V" \
#"p11708 wb 27 coe B83-wb ${ref_freq_wb_1g} 0.0 V" \
#35
#"p11708 wb 31 coe B85-wb ${ref_freq_wb_1g} 0.0 V" \
#"f22l11 tr 28 coe B97-tr ${ref_freq_tr_1g} 0.0 V TODO: actually 3 comp?" \
#"p11715 wb 14 coe B101-wb ${ref_freq_wb_1g} 0.0 V TODO: possible microshot?" \
#"p11717 wb 06 coe B103-wb ${ref_freq_wb_1g} 0.0 V t16" \
#"p11717 wb 36 coe B104-wb ${ref_freq_wb_1g} 0.0 V t32" \
#40
#"p11717 wb 42 coe B105-wb ${ref_freq_wb_1g} 0.0 V" \
#"p11719 wb 08 coe B106-wb ${ref_freq_wb_1g} 0.0 V" \
#"p11719 wb 19 coe B107-wb ${ref_freq_wb_1g} 0.0 V" \
#"f22l16 tr 11 coe B111-tr ${ref_freq_tr_1g} 0.0 V" \
#"f22l24 tr 27 coe B130-tr ${ref_freq_tr_1g} 0.0 TODO: fluence" \
#45
#"f22l46 tr 19 coe B132-tr ${ref_freq_tr_1g} 0.0 V" \
#46

#Pband bursts 16
#"p11714 wb 35 coe B100-wb ${ref_freq_wb_p} 0.0 t2 V" \
#"p11720 wb 36 coe B109-wb ${ref_freq_wb_p} 0.0 t2 V" \
#"p11721 wb 46 coe B110-wb ${ref_freq_wb_p} 0.0 t2 V" \
#"p11730 wb 33 coe B115-wb ${ref_freq_wb_p} 0.0 V" \-
#"p11739 wb 18 coe B117-wb ${ref_freq_wb_p} 0.0 V" \
#"p11743 wb 43 coe B118-wb ${ref_freq_wb_p} 0.0 t4 V" \
#"p11744 wb 25 coe B119-wb ${ref_freq_wb_p} 0.0 V (double?)" \
#"p11747 wb 20 coe B120-wb ${ref_freq_wb_p} 0.0 V" \
#"p11747 wb 42 coe B121-wb ${ref_freq_wb_p} 0.0 V (quad?)" \
#"p11747 wb 43 coe B122-wb ${ref_freq_wb_p} 0.0 t4 V" \
#"p11748 wb 20 coe B123-wb ${ref_freq_wb_p} 0.0 t4 V" \
#"p11748 wb 23 coe B124-wb ${ref_freq_wb_p} 0.0 t4 V" \
#"p11748 wb 41 coe B125-wb ${ref_freq_wb_p} 0.0 t2 V" \
#"p11749 wb 22 coe B126-wb ${ref_freq_wb_p} 0.0 t2 V" \
#"p11749 wb 26 coe B127-wb ${ref_freq_wb_p} 0.0 t2 V" \
#"p11749 wb 30 coe B128-wb ${ref_freq_wb_p} 0.0 V" \

#Stockert bursts
#"stocke st 59867_5457019 st B01-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59868_7161709 st B02-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59868_8024511 st B03-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59868_8913731 st B04-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59869_0504865 st B07-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59869_5823857 st B08-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59869_5889749 st B09-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59869_6732821 st B10-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59869_6775029 st B11-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59869_8182693 st B12-st ${ref_freq_st_1g} 219.37 V" \
#10
#"stocke st 59869_9461188 st B13-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59870_3644522 st B17-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59870_3736731 st B18-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59870_7739324 st B19-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59870_9153494 st B20-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59872_2649771 st B25-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59872_4678143 st B26-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59872_4679597 st B27-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59872_7005798 st B28-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59873_5332614 st B29-st ${ref_freq_st_1g} 219.37 V" \
#20
#"stocke st 59873_8236494 st B30-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59874_0936399 st B31-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59874_2154128 st B32-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59876_6610997 st B34-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59877_5565197 st B35-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59877_5948106 st B36-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59878_3813848 st B38-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59878_7374068 st B39-st ${ref_freq_st_1g} 219.37 V redone 19-dec-23" \
#"stocke st 59880_3955592 st B40-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59880_4029325 st B41-st ${ref_freq_st_1g} 219.37 V" \
#30
#"stocke st 59880_4410798 st B42-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59880_5668726 st B43-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59882_6488856 st B47-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59883_4632665 st B48-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59883_7188223 st B49-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59884_4339420 st B50-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59886_6610037 st B53-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59888_1332505 st B54-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59889_5497605 st B56-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59889_7032667 st B57-st ${ref_freq_st_1g} 219.37 V" \
#40
#"stocke st 59889_8204134 st B58-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59890_2591360 st B59-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59890_3176210 st B60-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59890_3953721 st B61-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59890_5626041 st B62-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59891_8065821 st B63-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59891_8858274 st B64-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59892_1979510 st B65-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59893_1379686 st B67-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59893_6497590 st B68-st ${ref_freq_st_1g} 219.37 V" \
#50
#"stocke st 59893_8524570 st B69-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59897_4974988 st B73-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59897_5807878 st B74-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59897_5915045 st B75-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59897_6168402 st B76-st ${ref_freq_st_1g} 219.37 V" \
"stocke st 59898_6292376 st B77-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59898_7174280 st B78-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59898_9401279 st B79-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59899_5376771 st B80-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59899_7846540 st B82-st ${ref_freq_st_1g} 219.37 V" \
#60
#"stocke st 59899_8813157 st B85-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59900_1998277 st B86-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59900_8515123 st B87-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59901_4075977 st B88-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59902_0387792 st B89-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59902_3813459 st B90-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59902_8121816 st B91-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59903_0112121 st B92-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59903_2531485 st B93-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59903_4752141 st B94-st ${ref_freq_st_1g} 219.37 V" \
#70
#"stocke st 59903_5553178 st B95-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59903_6046766 st B96-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59904_2669548 st B98-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59905_7441603 st B99-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59908_4923867 st B102-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59908_8837303 st B104-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59910_5777429 st B106-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59910_7022024 st B107-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59911_6579317 st B108-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59917_2312582 st B112-st ${ref_freq_st_1g} 219.37 V" \
#80
#"stocke st 59917_2650104 st B113-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59917_5089328 st B114-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59925_0072834 st B116-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59949_8819706 st B129-st ${ref_freq_st_1g} 219.37 V" \
#"stocke st 59978_5334682 st B131-st ${ref_freq_st_1g} 219.37 V" \
#85
)

basedir=/data1/omar/
dbdir=/home/omar/git/r117-single-dish-analysis/dbs/

get_MJD=./python/get_MJD.py

for run in "${runs[@]}";do
    IFS=" " read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    scan="${info[2]}"
    loc="${info[3]}"
    id="${info[4]}"
    refFreq="${info[5]}"
    dm="${info[6]}"
    src='sfxc'
    src_dir='sfxc'
    freqref="--ref_freq ${refFreq}"
    if [[ ${refFreq} == 'none' ]];then
        freqref=''
    fi

    #The name of stockert burst will be the MJD of detection
    if [[ ${dish} == 'st' ]];then
        arbase=${exp}_${scan}
    else
        arbase=${exp}_${dish}_no00${scan}
    fi

    expbasedir=${basedir}/${exp}
    arfile=${expbasedir}/${src_dir}/${arbase}.ds.pazi
    filfile=${expbasedir}/${src_dir}/${arbase}.ds.fil

    #rule for burst_time 2.0 and 0.5 seconds for P- and L-band
    if [[ "$refFreq" = "$ref_freq_wb_p" ]]; then
        burst_time_s=2.0 
        db="${dbdir}/burst_info_P.pickle"  # everything goes here for Pband
    elif [[ "$refFreq" = "$ref_freq_st_1g" ]]; then
        burst_time_s=1.5 
        db="${dbdir}/burst_info_V1.pickle"  # everything goes here for Lband
    else 
        burst_time_s=0.5
        db="${dbdir}/burst_info_V1.pickle"  # everything goes here for Lband
    fi

    cmd="python3 ${get_MJD} -d ${dm} --db ${db} --src ${src} --arfile ${arfile} --fscrunch ${fscrunch} --tscrunch ${tscrunch} --burst_time ${burst_time_s} --ID ${id} ${freqref} --location ${loc} ${filfile} --show_dynspec"

    echo "running ${cmd}"
    eval ${cmd}
done
