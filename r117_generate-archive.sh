#!/bin/bash

# Kirsten & Ould-Boukattine (2023) 
# Script takes the SFXC created filterbanks and converts them to archives files

# The script also checks if the final time resoltuon is a factor of 2, if this is not the case (7.999us-bins) for example
# Then this can be solved by changing the start_time of the archive file (by 0,01), it's behavior I suspect has to do with rounding of start time

# dont forget the extra space at the end of the line, before the \, otherwise it won't run
# middle = location of the burst in the sfxc filterbank, used prepdata to see the location (plots in evernote)
# cepoch = shift to left in seconds

# ToDo

# logs
# 2023-03-16, processed all SFXC L-band bursts! :D 
# 2023-05-23, processed all SFXC P-band bursts, all at the same time- and freq- resolution. Apples will be needin Apples

runs=( \
# exp   dish scan band direc middle cepoch_s filterbank
# L-band
#"p11701 wb 23 L p11701_23 0.8 0.20 p11701_23_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11701 wb 31 L p11701_31 1.605 0.33 p11701_31_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11702 wb 39 L p11702_39 0.92 0.33 p11702_39_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11703 wb 09 L p11703_09 1.286 0.30 p11703_09_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11703 wb 28 L p11703_28 1.385 0.08 p11703_28_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11703 wb 46 L p11703_46 1.02 0.44 p11703_46_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11704 wb 33 L p11704_33 1.07 0.38 p11704_33_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11704 wb 40 L p11704_40 1.465 0.2 p11704_40_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11708 wb 18 L p11708_18 1.161 0.30 p11708_18_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11708 wb 22 L p11708_22 1.24 0.09 p11708_22_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#10
#"p11708 wb 27 L p11708_27 0.511 0.15 p11708_27_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11708 wb 31 L p11708_31 0.778 0.24 p11708_31_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11715 wb 14 L p11715_14 1.09 0.48 p11715_14_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11717 wb 06 L p11717_06 0.95 0.30 p11717_06_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11717 wb 36 L p11717_36 1.40 0.36 p11717_36_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11717 wb 42 L p11717_42 1.09 0.28 p11717_42_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11719 wb 08 L p11719_08 1.095 0.19 p11719_08_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"p11719 wb 19 L p11719_19 1.391 0.34 p11719_19_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn019 wb 01 L pcn019_01 0.80 0.41 pcn019_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn019 wb 08 L pcn019_08_1 1.371 0.51 pcn019_08_1_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#20
#"pcn019 wb 08 L pcn019_08_2 1.091 0.38 pcn019_08_2_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn021 wb 02 L pcn021_02 1.32 0.29 pcn021_02_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn021 wb 05 L pcn021_05 0.95 0.08 pcn021_05_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn021 wb 09 L pcn021_09 1.31 0.04 pcn021_09_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn022 wb 01 L pcn022_01 1.40 0.18 pcn022_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn023 wb 07 L pcn023_07 1.05 0.26 pcn023_07_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn025 wb 01 L pcn025_01 0.685 0.45 pcn025_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn027 wb 04 L pcn027_04 0.98 0.28 pcn027_04_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn029 wb 05 L pcn029_05 0.883 0.22 pcn029_05_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn030 wb 04 L pcn030_04 0.98 0.42 pcn030_04_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#30
#"pcn037 wb 12 L pcn037_12 0.923 0.45 pcn037_12_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn037 wb 15 L pcn037_15 0.70 0.37 pcn037_15_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn038 wb 01 L pcn038_01 0.82 0.09 pcn038_01_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"pcn040 wb 10 L pcn040_10 0.68 0.00 pcn040_10_8us_125KHz_StokesI_DM21937_cor_Wb.fil" \
#"r67l62 tr 11 L r67l62_11 0.655 0.36 r67l62_11_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"r67l62 tr 15 L r67l62_15 1.45 0.49 r67l62_15_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"r67l62 tr 23 L r67l62_23 1.052 0.105 r67l62_23_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l01 tr 28 L f22l01_28 0.70 0.46 f22l01_28_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l01 tr 41 L f22l01_41 1.28 0.41 f22l01_41_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l01 tr 42 L f22l01_42 0.996 0.28 f22l01_42_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#40
#"f22l02 tr 28 L f22l02_28 1.01 0.27 f22l02_28_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l03 tr 37 L f22l03_37 0.83 0.50 f22l03_37_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l06 tr 03 L f22l06_03 0.58 0.35 f22l06_03_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l11 tr 28 L f22l11_28 1.01 0.38 f22l11_28_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l16 tr 11 L f22l16_11 0.55 0.48 f22l16_11_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l24 tr 27 L f22l24_27 1.21 0.15 f22l24_27_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#"f22l46 tr 19 L f22l46_19 0.511 0.28 f22l46_19_8us_125KHz_StokesI_DM21937_cor_Tr.fil" \
#47 L-band bursts
#""\
#P-band; these burst are processed at DM 219.7
#"p11714 wb 35 P p11714_35_p 2.7 0.70 p11714_35_256us_31KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11720 wb 36 P p11720_36_p 2.6 1.45 p11720_36_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11721 wb 46 P p11721_46_p 2.9 1.40 p11721_46_256us_32KHz_StokesI_DM2197_cor_Wb.fil D " \
#"p11730 wb 33 P p11730_33_p 2.05 2.0 p11730_33_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11739 wb 18 P p11739_18_p 2.25 0.6 p11739_18_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11743 wb 43 P p11743_43_p 3.0 1.90 p11743_43_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11744 wb 44 P p11744_25_p 2.4 0.00 p11744_25_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11747 wb 20 P p11747_20_p 2.2 0.40 p11747_20_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11747 wb 42 P p11747_42_p 2.2 0.00 p11747_42_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11747 wb 43 P p11747_43_p 2.3 0.95 p11747_43_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11748 wb 20 P p11748_20_p 2.7 1.40 p11748_20_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11748 wb 23 P p11748_23_p 3.0 1.20 p11748_23_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11748 wb 41 P p11748_41_p 2.1 1.30 p11748_41_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11749 wb 22 P p11749_22_p 2.8 1.10 p11749_22_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11749 wb 26 P p11749_26_p 1.1 0.65 p11749_26_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
#"p11749 wb 30 P p11749_30_p 2.6 0.30 p11749_30_256us_32KHz_StokesI_DM2197_cor_Wb.fil D" \
)

#Create directory for the archive files
basedir=/data1/omar/sfxc/r117
archive_dir=/fil_to_archives

outdir_archive=${basedir}/${archive_dir}
if ! [ -d ${outdir_archive} ];then
    mkdir -p ${outdir_archive}
fi

for run in "${runs[@]}";do

    #Read the run line using the read function
    read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    scan="${info[2]}"
    band="${info[3]}"
    direc="${info[4]}"
    middle_b="${info[5]}"
    cepoch_s="${info[6]}"
    filterbank="${info[7]}"

    #Setting the DM for L- and P-band
    if [[ "$band" = "L" ]]; then
        dm=219.37
        time_res=0.000008
        #time_res=0.000128 #you can also apply downsampling, makes alligning for faint burst easy
        lenght_archive=0.524288 #2**16*8e-6
        echo "Setting DM to $dm"
    elif [[ "$band" = "P" ]]; then
        dm=219.7
        time_res=0.000256 
        lenght_archive=2.097152 #2**13*256e-6
        echo "Setting DM to $dm"
    fi

    #calculate the number of bins based on the lenght and time_res
    nbins=`echo "${lenght_archive}/${time_res}" | bc -l | cut -d '.' -f1`

    #Start time of the archive file
    start_b=`echo "${middle_b} - ${lenght_archive}/2" | bc -l`

    #From documentation of CEPOCH
    #To specify a different epoch (e.g. the middle of the observation) use the EPOCH key with value specified as MJD.
    #So we convert from seconds to MJD to define the shift to left.
    #In order for CEPOCH to work you need a 0. infront of the number, so using sed we add a 0, see link below
    cepoch_mjd=`echo "(( ${cepoch_s} / ( 24 * 3600 ) ))" | bc -l | sed -e 's/^-\./-0./' -e 's/^\./0./'`

    echo "${exp} ${dish} ${scan} ${band} ${direc} ${cepoch_mjd} ${filterbank}"

    filterbank_in_dir=${basedir}/${direc}/${filterbank}
    archive_out_nm=${outdir_archive}/${filterbank/./_}
    echo $archive_out_nm

    #runnig dspsr to create an archive file
    dspsr_cmd="dspsr -c ${lenght_archive} -T ${lenght_archive} -S ${start_b} -b ${nbins} -cepoch ${cepoch_mjd} -O ${archive_out_nm} ${filterbank_in_dir}"
    echo $dspsr_cmd
    ${dspsr_cmd}

    #Name of the archive file with extension
    archive_out_nm_ar=${archive_out_nm}.ar

    #A check to see if the the amount of bins and output time is correct
    pars=`psredit -q -Q -c nbin,length,npol,nchan,bw ${archive_out_nm_ar}`
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
    echo "length=${length}, nbin=${nbin}, npol=${npol}"
    echo "nchan=${nchan}, bw=${bw}"
    echo "time_res=${time_res}, freq_res=${freq_res}"

    if [[ $((${time_res} % 2)) != 0 ]]; then
        echo "ALERT ALERT ALERT LOOK AT THE START TIME, current time res is: $time_res"
        continue
    fi

    #adding the info regarding the DM, machine and DMC to the archive file
    #Add the DM value 
    dspsr_cmd_dm="psredit -m -c dm=${dm} ${archive_out_nm_ar}"
    #echo $dspsr_cmd_dm
    ${dspsr_cmd_dm}

    #Add the fact that the burst is already straight, dmc=1
    dspsr_cmd_dmc="psredit -m -c dmc=1 ${archive_out_nm_ar}"
    #echo $dspsr_cmd_dmc
    ${dspsr_cmd_dmc}
     
    #Downsample factor for diagnostic plots
    time_down=8
    freq_down=4
    
    freq_res_khz=`echo "${freq_res}/1000" | bc` #convert to khz

    #Generate the new time- and freq resoltuon
    plt_time_res=`echo "$time_res*$time_down" | bc` #us
    plt_freq_res=`echo "$freq_res_khz*$freq_down" | bc` #khz
    echo "Making a diagnostic plot with time_res=${plt_time_res} us and freq_res=${plt_freq_res} hz"

    psrplot -pfreq+ -c x:unit=s -D /CPS -jpDT -j 'F x'"${freq_down}" -j 'B x'"${time_down}" ${archive_out_nm_ar}

    #${parameter//pattern/string}
    #Replace the old time and freq-res with the new in the archive string
    #Only search for time_res+us, otherwise you will also replace numbers in the scan
    new_name_t=`echo "${archive_out_nm_ar/${time_res}"us"/${plt_time_res}"us"}"`
    new_name_tf=`echo "${new_name_t/${freq_res_khz}"KHz"/${plt_freq_res}"KHz"}"`
    #echo "${new_name_tf}"
    mv pgplot.ps ${new_name_tf}.ar.ps

done

#Regarding the sed expression
#https://stackoverflow.com/questions/8402181/how-do-i-get-bc1-to-print-the-leading-zero

#making into a ps plot
#psrplot -pfreq+ -c x:unit=s -D /CPS -jpDT -j 'F x4' -j 'B x8' ${outdir}/${ar_scale}
#mv pgplot.ps ${outdir}/${ar_scale}.ps



