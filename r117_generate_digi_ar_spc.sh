#!/bin/bash
#
#########
# Kirsten & Ould-Boukattine 2023

# This script assumes that the VDIF files were already split
# into individual subbands and live somewhere on disk. 
# It performs the following steps:
# - using 'digifil', it will create Stokes I filterbank files for each subband
# - using 'dspsr', it will create archives files, attempting to have the pulse in the middle
# - each ar-file (one per subband) will first be scaled
# - the scaled ar-files with then be corrected using psrchive's SPC alogorithm
# - the scaled ar-files will be co-added to have the full band in one archive
# - the first scaled and then SPC'ed ar-files will be co-added to have the full band in one archive
# - a diff-archive of the scaled and the SPC'ed file will be generated
# - diagnostic plots of the scaled, SPC'ed, diff'ed archives are generated
#
#
# Todo: Add time- freq, resolution and bw per burst

pwait() {
    while [ $(jobs -p | wc -l) -ge $1 ]; do
	sleep 0.33
    done
}
njobs=16
expcounters=( 7 ) # this is zero based!

bw64=64000000
bw128=128000000
bw256=256000000
bw512=512000000

subbw8=8000000
subbw16=16000000
subbw32=32000000

# p11704-40 length archive file was 1.04 seconds, due to power difference in RFI
# todo:
# f22l03-37
# f22l24-27 is RFI LAND

# You cant place a space after the \ at the eol
runs=( \
# exp dish scan bw     subbandbw  cepoch_s    scaling factor for spc index
"p11701 wb 23 L ${bw128} ${subbw16} 0.50 0.50 0" \
"p11701 wb 31 L ${bw128} ${subbw16} 0.12 0.50 1" \
"p11702 wb 39 L ${bw128} ${subbw16} 0.65 0.50 2" \
"p11703 wb 09 L ${bw128} ${subbw16} 1.67 0.40 3" \
"p11703 wb 28 L ${bw128} ${subbw16} 1.45 0.50 4" \
"p11703 wb 46 L ${bw128} ${subbw16} 0.77 0.50 5" \
"p11704 wb 33 L ${bw128} ${subbw16} 0.71 0.50 6" \
"p11704 wb 40 L ${bw128} ${subbw16} 0.50 0.50 7" \
"p11708 wb 18 L ${bw128} ${subbw16} 0.10 0.50 8" \
"p11708 wb 22 L ${bw128} ${subbw16} 1.45 0.50 9" \
"pcn019 wb 08 L ${bw128} ${subbw16} 1.88 0.50 10" \
"p11708 wb 27 L ${bw128} ${subbw16} 1.00 0.50 11" \
"p11708 wb 31 L ${bw128} ${subbw16} 0.04 0.50 12" \
"p11715 wb 14 L ${bw128} ${subbw16} 0.80 0.50 13" \
"p11717 wb 06 L ${bw128} ${subbw16} 1.68 0.50 14" \
"p11717 wb 36 L ${bw128} ${subbw16} 0.15 0.50 15" \
"p11717 wb 42 L ${bw128} ${subbw16} 0.08 0.50 16" \
"p11719 wb 08 L ${bw128} ${subbw16} 0.50 0.50 17" \
"p11719 wb 19 L ${bw128} ${subbw16} 1.70 0.50 18" \
"pcn019 wb 01 L ${bw128} ${subbw16} 1.78 0.50 19" \
"pcn019 wb 08 L ${bw128} ${subbw16} 1.89 0.50 20" \
#20
"pcn019-2 wb 08 L ${bw128} ${subbw16} 1.23 0.50 21" \
"pcn021 wb 02 L ${bw128} ${subbw16} 1.65 0.50 22" \
"pcn021 wb 05 L ${bw128} ${subbw16} 1.45 0.50 23" \
"pcn021 wb 09 L ${bw128} ${subbw16} 0.90 0.50 24" \
"pcn022 wb 01 L ${bw128} ${subbw16} 0.50 0.50 25" \
"pcn023 wb 07 L ${bw128} ${subbw16} 0.58 0.50 26" \
"pcn025 wb 01 L ${bw128} ${subbw16} 0.25 0.50 27" \
"pcn027 wb 04 L ${bw128} ${subbw16} 1.13 0.50 28" \
"pcn029 wb 05 L ${bw128} ${subbw16} 1.05 0.50 29" \
"pcn030 wb 04 L ${bw128} ${subbw16} 1.27 0.50 30" \
#30
"pcn037 wb 12 L ${bw128} ${subbw16} 0.75 0.50 31" \
"pcn037 wb 15 L ${bw128} ${subbw16} 0.70 0.50 32" \
"pcn038 wb 01 L ${bw128} ${subbw16} 1.98 0.50 33" \
"pcn040 wb 10 L ${bw128} ${subbw16} 1.37 0.50 34" \
"r67l62 tr 11 L ${bw128} ${subbw16} 1.72 0.50 35" \
"r67l62 tr 15 L ${bw128} ${subbw16} 0.80 0.50 36" \
"r67l62 tr 23 L ${bw128} ${subbw16} 2.00 0.63 37" \
"f22l01 tr 28 L ${bw128} ${subbw16} 1.82 0.55 38 256ms" \
"f22l01 tr 41 L ${bw128} ${subbw16} 1.78 0.50 39" \
"f22l01 tr 42 L ${bw128} ${subbw16} 1.12 0.50 40" \
#40
"f22l02 tr 28 L ${bw128} ${subbw16} 1.63 0.50 41" \
"f22l03 tr 37 L ${bw128} ${subbw16} 0.00 0.50 42" \
"f22l06 tr 03 L ${bw128} ${subbw16} 0.15 0.50 43" \
"f22l11 tr 28 L ${bw128} ${subbw16} 0.70 0.50 44" \
"f22l16 tr 11 L ${bw128} ${subbw16} 1.85 0.50 45" \
"f22l24 tr 27 L ${bw128} ${subbw16} 0.96 0.50 46" \
"f22l46 tr 19 L ${bw128} ${subbw16} 0.70 0.55 47" \
#Pband
"p11714 wb 35 P ${bw64} ${subbw8} 1.20 0.50 48" \
"p11720 wb 36 P ${bw64} ${subbw8} 4.00 0.50 49" \
"p11721 wb 46 P ${bw64} ${subbw8} 4.00 0.50 50" \
"p11730 wb 33 P ${bw64} ${subbw8} 2.40 0.50 51" \
"p11739 wb 18 P ${bw64} ${subbw8} 3.00 0.50 52" \
"p11743 wb 43 P ${bw64} ${subbw8} 2.20 0.50 53" \
"p11744 wb 25 P ${bw64} ${subbw8} 2.50 0.50 54" \
"p11747 wb 20 P ${bw64} ${subbw8} 2.90 0.50 55" \
"p11747 wb 42 P ${bw64} ${subbw8} 0.40 0.50 56" \
"p11747 wb 43 P ${bw64} ${subbw8} 1.40 0.50 57" \
"p11748 wb 20 P ${bw64} ${subbw8} 4.00 0.50 58" \
"p11748 wb 23 P ${bw64} ${subbw8} 3.75 0.50 59" \
"p11748 wb 41 P ${bw64} ${subbw8} 1.80 0.50 60" \
"p11749 wb 22 P ${bw64} ${subbw8} 1.60 0.50 61" \
"p11749 wb 26 P ${bw64} ${subbw8} 3.20 0.60 62" \
"p11749 wb 30 P ${bw64} ${subbw8} 0.70 0.50 63" \
)

# 4.15e6 * 219.37 * (1207^-2 - (1207+0.0625)^-2) = 0.06471 ms
# We have to create 128 us timebins with 62.5 KHz channels in order for SPC to work, if we want for some reason finer freq channels then we can go to:
# 31.25 KHz (Nyquist is at 32 us) with 64 us time bins, then we have finer time- and freq resolution
# Got the advice to not make it to fine, the purpose is to measure the fluence, not any finer structure
# We should go to coarser time- and freq- resolution for some bursts, since they are so weak.
# TODO implement different time- and freq- options for bursts, BUT needs to be the same for SFXC, apples to apples

#Pband
#freq_resolution=3906.25 #16K channels for Pband
#freq_resolution=7812.5

#freq_resolution=31250.0  #Hz; equiv of 16e6/512; allows for 32e-6s time bins for 16MHz subbands
#freq_resolution=62500.0  # however, we have to go to 64e-6s time bins for spc to work; the DM-smearing
                          # in the lowest channel is more than 32e-6s.
#freq_resolution=31250.0  # spc doesn't work on all subbands with this freq setting


#time_res=0.000064
#time_res=0.000128
#time_res=0.000256 
#time_res=0.000512 # For p11717-wb-06 // pcn023-wb-07 // pcn038-wb-01 // pcn040-wb-10
                   # r67l62-23 only works with 512 ms time res
                  # For P-band; otherwise SPC does not work
#time_res=0.001024
#time_res=0.002048

basedir=/data1/omar/
vdif_base_odd=/scratch0/omar/
vdif_base_even=/scratch1/omar/
dir_in_outdir=scale_spc/

#dspsr=/home/franz/dspsr-installs/vdif-devel/bin/dspsr
dspsr=/home/franz/dspsr-installs/latest/bin/dspsr
digifil=/home/franz/dspsr-installs/latest/bin/digifil

#old version // sweep present in dynamic spectrum // DO NOT USE
#digifil=/home/franz/software/src/dspsr/Signal/General/digifil
#dspsr=/home/franz/software/src/dspsr/Signal/Pulsar/dspsr

pam=`which pam`
#dspsr=`which dspsr`
#digifil=`which digifil`

# we create archives on a per subband level, then scale them, spc them, psradd them.
# need to have NPOL 2 in hdr files for vdif-devel dspsr to work.
for expcounter in "${expcounters[@]}";do
    run="${runs[${expcounter}]}"
#for run in "${runs[@]}";do
    IFS=" " read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    scan="${info[2]}"
    band="${info[3]}"
    bw="${info[4]}"
    subbandbw="${info[5]}"
    cepoch_s="${info[6]}"
    scale="${info[7]}"

    nif=`echo "${bw}/${subbandbw}" | bc | cut -d '.' -f1`
    
    #Setting the DM for L- and P-band
    if [[ "$band" = "L" ]]; then
        dm=219.37
        nif_used=${nif}
     
        #Default // 128us,625
        time_res=0.000128 #you can also apply downsampling, makes alligning for faint burst easy
        freq_resolution=62500.0
        #freq_resolution=125000.0
        #length=2.097152

        #p11704-40, start_b=2.01
        length=1.048576

        #Lenght digifil filterbanks; account for the sweep while leaving guassian noise in the file
        digi_l=3.9

        #The .vdif frames on disk are 4 seconds long (L-band), we want the middle 2 seconds with the burst, so we Seek 1 second into the file.
        start_b=1.00

        #Downsample commands at the end of the script
        pam_tscrunch=1
        pam_fscrunch=2 #To get it to 125 KHz

        echo "Setting DM to $dm"
    elif [[ "$band" = "P" ]]; then
        dm=219.7
        #We only want to use the first 7 IFs on P-band
        nif_used=`echo "${nif}-1" | bc`

        #Settings to mitigate residual smeering as much as possible // downsample in freq at the bottom of this script
        time_res=0.000512 
        freq_resolution=3906.25

        #Lenght digifil filterbanks; account for the sweep while leaving guassian noise in the file
        digi_l=9.9

        length=4.194304

        #For P-band the .vdif frames are 10 seconds long, where the burst is placed at the 3-4 second mark, so we Seek 3 second into the file.
        start_b=3.0

        #P-band
        #!Important, in order for SPC to work, no smearing needs to present. So we initially create 16K channels. For the workflow, we use 2048 channels overall. 
        #Therefore for the archive file that is used in the Fluence computation we downsample in frequency with factor 8 (P-band).
        pam_tscrunch=1
        pam_fscrunch=8
        
        echo "Setting DM to $dm"
    fi

    echo "${exp} ${dish} ${band} ${scan} ${bw} ${subbandbw} ${cepoch} ${nif_used} ${dm}"
    nbins=`echo "${length}/${time_res}" | bc -l | cut -d '.' -f1`

    #cepoch is given in seconds above, here we convert to MJD and add a leading 0. 
    cepoch=`echo "(( ${cepoch_s} / ( 24 * 3600 ) ))" | bc -l | sed -e 's/^-\./-0./' -e 's/^\./0./'`

    #Define the outdir
    outdir=${basedir}/${exp}/${dir_in_outdir}

    #Make the outdir in case did not exist.
    if ! [ -d ${outdir} ];then
	    mkdir -p ${outdir}
    fi
    
    nchans=`echo "${subbandbw}/${freq_resolution}" | bc | cut -d '.' -f1`
    leakage_factor=`echo "${nchans}*4" | bc | cut -d '.' -f1`

    for IF in `seq 1 ${nif_used}`;do
	    hdr=${exp}_${dish}_no00${scan}_IF${IF}.vdif_pol2.hdr

        #Remove .hdr 
	    ar=${outdir}/${hdr%.hdr}

        #check if IF is odd, then input dir is different
        #Why is this important?
        vdif_base=${vdif_base_even}
        if (( IF % 2 )); then
            vdif_base=${vdif_base_odd}
        fi

        #Remove any filterbanks that were already there in the output folder (handy in case we rerun)
        rm ${ar}.fil

        #Digifil command
        cmd="${digifil} -I0.0 -b8 -D0.0 -d1 -F${nchans}:${leakage_factor} -T ${digi_l} -o ${ar}.fil ${vdif_base}/${exp}/${hdr} && "

        #echo "ALERT ALERT ALERT THIS IS THE DM USED: $dm"
        cmd=${cmd}"${dspsr} -S ${start_b} -b ${nbins} -D ${dm} -c ${length} -T ${length} -cepoch ${cepoch} ${ar}.fil -O ${ar}.fil && "
        cmd=${cmd}"./spc/scale_${scale}.sh -e scale.ar ${ar}.fil.ar && "
        cmd=${cmd}"./spc/spc.sh -e spc.ar ${ar}.fil.scale.ar && "
        cmd=${cmd}"${pam} -f ${pam_fscrunch} -e ds.ar ${ar}.fil.scale.ar && "
        cmd=${cmd}"${pam} -f ${pam_fscrunch} -e ds.ar ${ar}.fil.scale.spc.ar "
        echo "$cmd"
        eval ${cmd} &
        pwait ${njobs}
    done
    wait

    # add the subbands into one
    #Define the files
    ar_scale=${exp}_${dish}_no00${scan}_allIFs.vdif_pol2.fil.scale.ar
    ar_spc=${exp}_${dish}_no00${scan}_allIFs.vdif_pol2.fil.scale.spc.ar
    ar_scale_ds=${exp}_${dish}_no00${scan}_allIFs.vdif_pol2.fil.scale.ds.ar
    ar_spc_ds=${exp}_${dish}_no00${scan}_allIFs.vdif_pol2.fil.scale.spc.ds.ar

    #Using psradd we will stitch the IFs together 
    psradd -R -o ${outdir}/${ar_scale} ${outdir}/${exp}_${dish}_no00${scan}_IF*.vdif_pol2.fil.scale.ar
    psradd -R -o ${outdir}/${ar_scale_ds} ${outdir}/${exp}_${dish}_no00${scan}_IF*.vdif_pol2.fil.scale.ds.ar
    psradd -R -o ${outdir}/${ar_spc} ${outdir}/${exp}_${dish}_no00${scan}_IF*.vdif_pol2.fil.scale.spc.ar
    psradd -R -o ${outdir}/${ar_spc_ds} ${outdir}/${exp}_${dish}_no00${scan}_IF*.vdif_pol2.fil.scale.spc.ds.ar

    #Making diag plots

    #Plot of the downsampled scaled_archived file
    psrplot -pfreq+ -c x:unit=s -D /CPS -jpDT -j 'F x1' -j 'B x8' ${outdir}/${ar_scale_ds}
    #psrplot -pfreq+ -c x:unit=s -D /CPS -jpDT -j 'F x4' -j 'B x8' ${outdir}/${ar_scale}
    mv pgplot.ps ${outdir}/${ar_scale_ds}.ps

    #Plot of the downsampled spc_archive file
    psrplot -pfreq+ -c x:unit=s -D /CPS -jpDT -j 'F x1' -j 'B x8' ${outdir}/${ar_spc_ds}
    mv pgplot.ps ${outdir}/${ar_spc_ds}.ps

    #psrdiff is to find the difference in profile; see the impact of the spc algorithm
    #Specifically the downsampled archive files
    psrdiff ${outdir}/${ar_scale_ds} ${outdir}/${ar_spc_ds}
    mv psrdiff.out ${outdir}/${exp}_${dish}_no00${scan}_scale_spc_diff_ds.ar
    psrplot -pD -c x:unit=s -D /CPS -jpFD ${outdir}/${exp}_${dish}_no00${scan}_scale_spc_diff_ds.ar
    mv pgplot.ps ${outdir}/${exp}_${dish}_no00${scan}_scale_spc_diff_ds.ar.ps

done
