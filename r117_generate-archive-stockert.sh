#!/bin/bash

# Kirsten & Ould-Boukattine (2023) 
# Script takes the cut out filterbank files as provided by Wolfgang and converts them to archive files with the burst in the middle

# The time sampling of Stockert: 218.45333 us, we create the archive file to be 2048 bins
# This will yield an archive file with lenght: 0.447391744 seconds

# The script also checks if the final time resoltuon is a factor of 2, if this is not the case (7.999us-bins) for example
# Then this can be solved by changing the start_time of the archive file (by 0,01), it's behavior I suspect has to do with rounding of start time

# dont forget the extra space at the end of the line, before the \, otherwise it won't run
# middle = location of the burst in the sfxc filterbank, assumed that the burst is at the 0.5 seconds mark
# cepoch = shift to left in seconds

# logs
# 2023-04-24: Adjusted the script based on the generate-archive.sh script 

runs=( \
# middle cepoch_s filterbank
# L-band
#"1.50 0.18 snip59867.5457019.fbspi.fil" \
#"0.75 0.267 snip59868.7161709.fbspi.fil" \
#"0.5 0.0 snip59868.8024511.fbspi.fil" \
#"0.5 0.17 snip59868.8913731.a.fbspi.fil faint" \
#"0.25 0.19 snip59869.0504865.fbspi.fil" \
#"0.6 0.20 snip59869.5823857.fbspi.fil" \
#"0.55 0.42 snip59869.5889749.fbspi.fil" \
#"0.4 0.12 snip59869.6732821.fbspi.fil" \
#"0.37 0.18 snip59869.6775029.fbspi.fil" \
#"0.5 0.39 snip59869.8182693.fbspi.fil" \
#"0.5 0.15 snip59869.9461188.fbspi.fil" \
#"0.5 0.28 snip59870.3644522.fbspi.fil" \
#"0.7 0.16 snip59870.3736731.fbspi.fil" \
#"0.5 0.07 snip59870.7739324.fbspi.fil RFI-zapping command" \
#"0.37 0.24 snip59870.9153494.fbspi.fil" \
#"0.5 0.33 snip59872.2649771.fbspi.fil" \
#"0.75 0.24 snip59872.4678143.fbspi.fil" \
#"0.5 0.27 snip59872.4679597.fbspi.fil" \
#"0.5 0.03 snip59872.7005798.fbspi.fil" \
#"0.34 0.43 snip59873.5332614.fbspi.fil played with the start time to remove RFI" \
#"0.7 0.22 snip59873.8236494.fbspi.fil" \
#"0.4 0.4 snip59874.0936399.fbspi.fil RFI-zapping command applied" \
#"0.5 0.27 snip59874.2154128.fbspi.fil" \
#"0.5 0.02 snip59876.6610997.fbspi.fil RFI-zapping command applied" \
#"0.5 0.0 snip59877.5565197.fbspi.fil" \
#"0.5 0.3 snip59877.5948106.fbspi.fil" \
#"0.5 0.18 snip59878.3813848.fbspi.fil RFI-zapping command applied" \
#"0.5 0.05 snip59878.7374068.fbspi.fil" \
#"0.5 0.18 snip59880.3955592.fbspi.fil" \
#"0.5 0.15 snip59880.4029325.fbspi.fil" \
#"0.5 0.15 snip59880.4410798.fbspi.fil" \
#"0.5 0.15 snip59880.5668726.fbspi.fil" \
#"0.5 0.22 snip59882.6488856.fbspi.fil" \
#"0.5 0.02 snip59883.4632665.fbspi.fil" \
#"0.5 0.34 snip59883.7188223.fbspi.fil RFI-zapping command applied" \
#"0.5 0.0 snip59884.4339420.fbspi.fil" \
#"0.5 0.42 snip59886.6610037.fbspi.fil" \
#"0.5 0.12 snip59888.1332505.fbspi.fil" \
#"0.5 0.34 snip59889.5497605.fbspi.fil" \
#"0.5 0.35 snip59889.7032667.fbspi.fil RFI-zapping command applied" \
#"0.5 0.03 snip59889.8204134.fbspi.fil" \
#"0.5 0.04 snip59890.2591360.fbspi.fil" \
#"0.5 0.22 snip59890.3176210.fbspi.fil" \
#"0.5 0.32 snip59890.3953721.fbspi.fil" \
#"0.5 0.0 snip59890.5626041.fbspi.fil" \
#"0.5 0.30 snip59891.8065821.fbspi.fil" \
#"0.5 0.22 snip59891.8858274.fbspi.fil" \
#"0.5 0.26 snip59892.1979510.fbspi.fil" \
#"0.5 0.06 snip59893.1379686.fbspi.fil" \
#"0.65 0.35 snip59893.6497590.fbspi.fil" \
#"0.5 0.32 snip59893.8524570.fbspi.fil" \
#"0.5 0.38 snip59897.4974988.fbspi.fil RFI-zapping command applied" \
#"0.5 0.22 snip59897.5807878.fbspi.fil" \
#"0.5 0.03 snip59897.5915045.fbspi.fil" \
#"0.5 0.4 snip59897.6168402.fbspi.fil" \
#"0.5 0.18 snip59898.6292376.fbspi.fil" \
#"0.5 0.32 snip59898.7174280.fbspi.fil" \
#"0.5 0.16 snip59898.9401279.fbspi.fil" \
#"0.5 0.30 snip59899.5376771.fbspi.fil" \
#"0.5 0.30 snip59899.7846540.fbspi.fil" \
#"0.5 0.42 snip59899.8813157.fbspi.fil RFI-zapping command applied" \
#"0.5 0.33 snip59900.1998277.fbspi.fil" \
#"0.5 0.29 snip59900.8515123.fbspi.fil" \
#"0.5 0.22 snip59901.4075977.fbspi.fil" \
#"0.55 0.39 snip59902.0387792.fbspi.fil" \
#"0.5 0.06 snip59902.3813459.fbspi.fil" \
#"0.5 0.37 snip59902.8121816.fbspi.fil" \
#"0.5 0.22 snip59903.0112121.fbspi.fil" \
#"0.5 0.04 snip59903.2531485.fbspi.fil RFI-zapping command applied" \
#"0.5 0.1 snip59903.4752141.fbspi.fil" \
#"0.5 0.36 snip59903.5553178.fbspi.fil" \
#"0.5 0.42 snip59903.6046766.fbspi.fil" \
#"0.5 0.30 snip59904.2669548.fbspi.fil" \
#"0.5 0.28 snip59905.7441603.fbspi.fil" \
#"0.5 0.16 snip59908.4923867.fbspi.fil" \
#"0.5 0.14 snip59908.8837303.fbspi.fil faint" \
#"0.5 0.42 snip59910.5777429.fbspi.fil" \
#"0.5 0.2 snip59910.7022024.fbspi.fil" \
#"0.5 0.12 snip59911.6579317.fbspi.fil" \
#"0.5 0.18 snip59917.2312582.fbspi.fil" \
#"0.5 0.28 snip59917.2650104.fbspi.fil" \
#"0.5 0.34 snip59917.5089328.fbspi.fil" \
#"0.5 0.14 snip59925.0072834.fbspi.fil" \
#"0.5 0.25 snip59949.8819706.fbspi.fil" \
"0.64 0.00 snip59978.5334682.fbspi.fil" \
)

#Create directory for the archive files
basedir=/data1/omar/sfxc/r117
archive_dir=/fil_to_archives_stockert

fil_dir=/scratch2/omar/burst-detections/r117/stockert-detections/r117-stk-burst

outdir_archive=${basedir}/${archive_dir}
if ! [ -d ${outdir_archive} ];then
    mkdir -p ${outdir_archive}
fi

#Define constants
dm=219.37
#218.453333333333
time_res=0.000218453 #time_resolution of all sfxc filterbanks
#time_res=0.000128 #you can also apply downsampling, makes alligning for faint burst easy
lenght_archive=0.447391744 #time_sample*2048

#calculate the number of bins based on the lenght and time_res
nbins=`echo "${lenght_archive}/${time_res}" | bc -l | cut -d '.' -f1`

for run in "${runs[@]}";do

    #Read the run line using the read function
    read -r -a info <<< "${run}"
    #exp="${info[0]}"
    #dish="${info[1]}"
    #scan="${info[2]}"
    #direc="${info[3]}"
    middle_b="${info[0]}"
    cepoch_s="${info[1]}"
    filterbank="${info[2]}"

    #Start time of the archive file
    start_b=`echo "${middle_b} - ${lenght_archive}/2" | bc -l`

    #From documentation of CEPOCH
    #To specify a different epoch (e.g. the middle of the observation) use the EPOCH key with value specified as MJD.
    #So we convert from seconds to MJD to define the shift to left.
    #In order for CEPOCH to work you need a 0. infront of the number, so using sed we add a 0, see link below
    cepoch_mjd=`echo "(( ${cepoch_s} / ( 24 * 3600 ) ))" | bc -l | sed -e 's/^-\./-0./' -e 's/^\./0./'`

    echo "${exp} ${dish} ${scan} ${direc} ${cepoch_mjd} ${filterbank}"

    filterbank_in_dir=${fil_dir}/${filterbank}
    archive_out_nm=${outdir_archive}/${filterbank/./_}
    echo $archive_out_nm

    #runnig dspsr to create an archive file
    #need to set machine as fake, otherwise we get an error regarding the processing machine pulsar2000 having to long a lenght
    dspsr_cmd="dspsr -set machine=fake -D ${dm} -c ${lenght_archive} -T ${lenght_archive} -S ${start_b} -b ${nbins} -cepoch ${cepoch_mjd} -O ${archive_out_nm} ${filterbank_in_dir}"
    echo $dspsr_cmd
    ${dspsr_cmd}

    #Name of the archive file with extension
    archive_out_nm_ar=${archive_out_nm}.ar

    #In case the RFI is so bad and you need to zap channels in order to see them in the diagnostic plot
    #First use the Pazi tool to figure our the channels, add them here below between "" and the script will zap them and the diagnostic plot will be updated accordinly.
    #paz -z "94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138" -e pazi ${archive_out_nm_ar}
    #archive_out_nm_ar=${archive_out_nm}.pazi

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
    #dspsr_cmd_dm="psredit -m -c dm=${dm} ${archive_out_nm_ar}"
    #echo $dspsr_cmd_dm
    #${dspsr_cmd_dm}

    #Add the fact that the burst is already straight, dmc=1
    #dspsr_cmd_dmc="psredit -m -c dmc=1 ${archive_out_nm_ar}"
    #echo $dspsr_cmd_dmc
    #${dspsr_cmd_dmc}
     
    #Downsample factor for diagnostic plots
    time_down=2
    freq_down=1
    
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

#Selecting all filterbanks for in this file
#ls *.fil | sort -t '/' -k 4 | sed -e 's;^;#"0.5 0.0 ;' | sed '$!s/$/" \\/'

#pazi command:
#snip59870.7739324 -- paz -z "143 144 145 146 147 141 142 148 149 140 150 151 101 102 103 139" 
#snip59874.0936399 -- paz -z "92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138" 
#snip59876.6610997 -- paz -z "134 135 136 137 138 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133"
#snip59878.3813848 -- paz -z "135 136 137 138 132 133 134 108 109 110 111 94 95 96 97 126 115 116 117 100 124 125 123 105 106 130 131 98 99"
#snip59883.7188223 -- paz -z "135 136 137 138 131 132 133 134 130 104 105 106 107 94 95 96 97 98 99 100 101 108 109 110 111 112 113 114 115 116 117 102 103 127 128 129 122 123 125 126 118 119 120 121"
#snip59889.7032667 -- paz -z "135 136 137 138 129 130 131 125 126 127 128 114 115 116 117 105 106 107 94 95 96 102 103 118 119 120 132 133 112 113 98 99 101 108 122 123"
#snip59897.4974988 -- paz -z "97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 52 53 54 55 56 69 70 71 72 73 74 75 135 136 137 133 134 123 124 125 126 127 128 122 131 132"
#snip59899.8813157 -- paz -z "97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 95 96"
#snip59903_2531485 -- paz -z "94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138"
