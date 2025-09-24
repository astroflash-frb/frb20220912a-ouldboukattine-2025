#!/bin/bash
#####
# frb-baseband at commit 7cdb40df396db7e7 -- NEED TO DOUBLE CHECK

# The time and freq resolution from running base2fil does not matter for the SPC algorithm (-n 512 -d 1), since we will not be using the filterbank files, but are intrested in the VDIF frames 
# The 'keepVDIF' split .vdif frames are the important step, there is an option to only split the .vdif frames, but that will not work in this setup.
# IN the base2fil script there are also .header (HDR) files written which digifil needs in the spc_ar file script, so we need to write out the .fil files

# Before running the created configs, one has to unmount possibly mounted observations (fusermount -u home/user/vbs_data/exp)

# The skip is roughly two seconds before the burst according to digifil for L-band
# The skip for P-band is double; just to be sure

# for bursts in same scan, cp the vdif file and HDR files with a 2 appended to it, this way you can process multiple bursts. For R117-camp, only 2 instances, so no script. Do manually

# exp dish scan skip
#"r67008 o8 17 3  " \
####
runs=( \
#"p11701 wb 23 538" \ 
#"p11701 wb 31 89" \
#"p11702 wb 39 557" \
#"p11703 wb 09 478" \
#"p11703 wb 28 602" \
#"p11703 wb 46 792" \
#"p11704 wb 33 143" \
#"p11704 wb 40 646" \
#"p11708 wb 18 437" \
#"p11708 wb 22 669" \
#"p11708 wb 27 355" \
#"p11708 wb 31 812" \
#"p11715 wb 14 299" \
#"p11717 wb 06 27" \
#"p11717 wb 36 364" \
#"p11717 wb 42 154" \
#"p11719 wb 08 25" \
#"p11719 wb 19 745" \
#"pcn019 wb 01 406" \
#"pcn019 wb 08 202 burst1"\
#20
#"pcn019 wb 08 814 burst2, renaming to pcn019-2" \
#"pcn021 wb 02 759" \
#"pcn021 wb 05 804" \
#"pcn021 wb 09 586" \
#"pcn022 wb 01 59" \
#"pcn023 wb 07 153" \
#"pcn025 wb 01 689" \
#"pcn027 wb 04 579" \
#"pcn029 wb 05 702" \
#"pcn030 wb 04 308" \
#30
#"pcn037 wb 12 268" \
#"pcn037 wb 15 660" \
#"pcn038 wb 01 344" \
#"pcn040 wb 10 113" \
#"r67l62 tr 11 556" \
#"r67l62 tr 15 420" \
#"r67l62 tr 23 453" \
#"f22l01 tr 28 50" \
#"f22l01 tr 41 287" \
#"f22l01 tr 42 148" \
#40
#"f22l02 tr 28 158" \
#"f22l03 tr 37 672" \
#"f22l06 tr 03 86" \
#"f22l11 tr 28 696" \
#"f22l16 tr 11 320" \
#"f22l24 tr 27 593" \
#"f22l46 tr 19 144" \
#47
##P-band
"p11714 wb 35 622"
#"p11730 wb 33 766" \
#"p11720 wb 36 807" \
#"p11721 wb 46 343" \
#50
#"p11739 wb 18 67" \
#"p11743 wb 43 709" \
#"p11744 wb 25 823" \
#"p11747 wb 20 229" \
#"p11747 wb 42 123" \
#"p11747 wb 43 315" \
#"p11748 wb 20 531" \
#"p11748 wb 23 466" \
#"p11748 wb 41 456" \
#"p11749 wb 22 676" \
#60
#"p11749 wb 26 268" \
#"p11749 wb 30 317" \
)

#lengths=4
#lengths=5 #For p11719_08, p11709_19, r67l62-11, r67l62-15, r67l62-23, f22l01-41, f22l16-11, f22l24-27
          #due to some rounding error somewhere, otherwise -T3.0

#Pband sweep is max 3.3 seconds: 3 seconds before -- 3.3 seconds sweep -- 3 seconds behind = 10 sec
lengths=10

expcounter=-1
for run in "${runs[@]}";do
    IFS=" " read -r -a info <<< "${run}"
    exp="${info[0]}"
    dish="${info[1]}"
    scan="${info[2]}"
    skip="${info[3]}"
    echo "${exp} ${dish} ${scan} ${skip}"
    conf_file=./confs/${exp}_${dish}_R117_scan${scan}.conf

    #if statement on source, if tr or wb
    if [ "${dish}" == "wb" ];then
	    source="FRB20220912A"
    elif [ "${dish}" == "tr" ];then
        source="F220912"
    fi

    create_config.py -t ${dish} -s ${source} \
                     --keepVDIF --keepBP --nbit=-32 -n 512 \
                     -N 20 -i ./vex/${exp}.vex \
		     -S ${scan} -o ${conf_file}
    sed -i -e "s/skips.*/skips=( ${skip} )/" ${conf_file}
    sed -i -e "s/lengths.*/lengths=( ${lengths} )/" ${conf_file}
done

#    if [[ ${exp} == 'r67022' ]]; then
#	sed -i -e "s/freqLSB_0.*/freqLSB_0=1468.0/" ${conf_file}
#    fi
