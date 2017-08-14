#!/bin/bash
# # # # # # # # # # # # # # # # # # #
# JUST A SCRIPT FOR WORLD DOMINATION, jk, it's just for butler repo stats
# THIS IS STILL A WORK IN PROGRESS!!!!

# CREATRIX: 	Samantha Thrush
# EMAIL:	thrush2@illinois.edu
# DATE CREATED: 31 May 2017
# LAST CHANGE:  17 July 2017
# # # # # # # # # # # # # # # # # # #
 
# HERE IS WHERE YOU INPUT THE BUTLER REPO'S THAT YOU WANT TO ANALYZE
DIR=(/datasets/hsc/repo/rerun/DM-10404/SFM)  #/datasets/hsc/repo/rerun/DM-10404/DEEP /datasets/hsc/repo/rerun/DM-10404/UDEEP /datasets/hsc/repo/rerun/DM-10404/WIDE)

#YOU MUST SPECIFY WHERE YOU WANT TO SEND THE OUTPUT FILES
WRITE=/scratch/thrush/butler_stats


for DIR1 in "${DIR[@]}" #iterating through the directories above
do
  cd $DIR1
  NUM="${DIR1##*/}" #allows me to differentiate between different output files
  
  ### GETTING SIZE OF BUTLER DIRECTORIES
  echo $NUM
  if [[ "$NUM" == "SFM" ]]; 
  then 
    echo "going through SMF script"
    # CORR files
    echo "CORR files" >>$WRITE/butler_stat-$NUM.txt
    find $DIR1/0*/*/corr -type f -name 'CORR-*.fits' -print0 |xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt
    
    # SRC files
    echo "SRC files" >>$WRITE/butler_stat-$NUM.txt
    echo "SRC"
    find $DIR1/0*/*/output -type f -name 'SRC-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt
    
    echo "SRCMATCH files" >>$WRITE/butler_stat-$NUM.txt
    echo "SRCMATCH"
    find $DIR1/0*/*/output -type f -name 'SRCMATCH-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt
 
    echo "SRCMATCHFULL files" >>$WRITE/butler_stat-$NUM.txt
    echo "SRCMATCHFULL"
    find $DIR1/0*/*/output -type f -name 'SRCMATCHFULL-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt
 
    echo "deepCoadd-SkyMap" >> $WRITE/butler_stat-$NUM.txt
    du -sc --apparent-size $DIR1/deepCoadd/skyMap.pickle >> $WRITE/butler_stat-$NUM.txt  
    
    echo "BKGD" >>$WRITE/butler_stat-$NUM.txt
    echo "BKGD"
    find $DIR1/0*/*/corr -type f -name 'BKGD-*.fits' -print0 | xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "boost files" >> $WRITE/butler_stat-$NUM.txt
    find $DIR1/0*/*/singleFrameDriver_metadata -type f -name '*.boost' -print0 |xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >>$WRITE/butler_stat-$NUM.txt

    echo "flattened files" >> $WRITE/butler_stat-$NUM.txt
    echo "flattened"
    find $DIR1/0*/*/thumbs -type f -name 'flattened-*.png' -print0 |xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >>$WRITE/butler_stat-$NUM.txt

    echo "oss files" >> $WRITE/butler_stat-$NUM.txt
    echo "oss"
    find $DIR1/0*/*/thumbs -type f -name 'oss-*.png' -print0 |xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >>$WRITE/butler_stat-$NUM.txt

    echo "deep_makeSkyMap.boost" >> $WRITE/butler_stat-$NUM.txt
    find $DIR1/metadata -type f -name 'deep_makeSkyMap.*' -print0 |xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >>$WRITE/butler_stat-$NUM.txt
     
    echo "icSrc" >> $WRITE/butler_stat-$NUM.txt
    find $DIR1/schema -type f -name 'icSrc.*' -print0 |xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >>$WRITE/butler_stat-$NUM.txt

    echo "scr" >> $WRITE/butler_stat-$NUM.txt
    find $DIR1/schema -type f -name 'src.*' -print0 |xargs -r0 du -a | awk '{sum+=$1} END {print sum}' >>$WRITE/butler_stat-$NUM.txt
    echo "horray! Done with SMF"

### NOW, on to DEEP, UDEEP, and WIDE ###
  else
    echo "FORCEDSRC" >>$WRITE/butler_stat-$NUM.txt
    echo "FORCEDSRC"
    find $DIR1/0*/*/tract* -type f -name 'FORCEDSRC-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "forcedPhotCcd_metadata" >>$WRITE/butler_stat-$NUM.txt
    echo "forcedPhotCcd_metadata"
    find $DIR1/0*/*/tract*/forcedPhotCcd_metadata -type f -name '*.boost' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt
      
    if [[ "$NUM" == "WIDE" ]];
    then 
      echo "warp" >>$WRITE/butler_stat-$NUM.txt
      echo "warp"
      find $DIR1/deepCoadd/HSC-G/*/* -type f -name 'warp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd/HSC-I/*/* -type f -name 'warp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd/HSC-R/*/* -type f -name 'warp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd/HSC-Y/*/* -type f -name 'warp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd/HSC-Z/*/* -type f -name 'warp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
  
      echo "mergeDet" >>$WRITE/butler_stat-$NUM.txt
      echo "mergeDet"
      find $DIR1/deepCoadd-results/merged/8*/* -type f -name 'mergeDet-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/9[0-3]*/* -type f -name 'mergeDet-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/9[4-6]*/* -type f -name 'mergeDet-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/9[7-9]*/* -type f -name 'mergeDet-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/1*/* -type f -name 'mergeDet-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      #find $DIR1/deepCoadd-results/merged/{11001..17000}/* -type f -name 'mergeDet-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

      echo "ref" >>$WRITE/butler_stat-$NUM.txt
      echo "ref"
      find $DIR1/deepCoadd-results/merged/8*/* -type f -name 'ref-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/9[0-3]*/* -type f -name 'ref-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/9[4-6]*/* -type f -name 'ref-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/9[7-9]*/* -type f -name 'ref-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/merged/1*/* -type f -name 'ref-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      #find $DIR1/deepCoadd-results/merged/{11001..17000}/* -type f -name 'ref-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt


      echo "calexp" >>$WRITE/butler_stat-$NUM.txt
      echo "calexp"
      find $DIR1/deepCoadd-results/HSC-G/*/* -type f -name 'calexp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-I/*/* -type f -name 'calexp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-R/*/* -type f -name 'calexp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Y/*/* -type f -name 'calexp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Z/*/* -type f -name 'calexp-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

      echo "det_bkgd" >>$WRITE/butler_stat-$NUM.txt
      echo "det_bkgd"
      find $DIR1/deepCoadd-results/HSC-G/*/* -type f -name 'det_bkgd-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-R/*/* -type f -name 'det_bkgd-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-I/*/* -type f -name 'det_bkgd-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Z/*/* -type f -name 'det_bkgd-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Y/*/* -type f -name 'det_bkgd-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

      echo "det" >>$WRITE/butler_stat-$NUM.txt
      echo "det"
      find $DIR1/deepCoadd-results/HSC-G/*/* -type f -name 'det-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-R/*/* -type f -name 'det-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-I/*/* -type f -name 'det-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Z/*/* -type f -name 'det-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Y/*/* -type f -name 'det-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

      echo "forced_src" >>$WRITE/butler_stat-$NUM.txt
      echo "forced_src"
      find $DIR1/deepCoadd-results/HSC-G/*/* -type f -name 'forced_src-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-R/*/* -type f -name 'forced_src-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-I/*/* -type f -name 'forced_src-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Z/*/* -type f -name 'forced_src-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Y/*/* -type f -name 'forced_src-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

      echo "meas" >>$WRITE/butler_stat-$NUM.txt
      echo "meas"
      find $DIR1/deepCoadd-results/HSC-G/*/* -type f -name 'meas-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-R/*/* -type f -name 'meas-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-I/*/* -type f -name 'meas-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Z/*/* -type f -name 'meas-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Y/*/* -type f -name 'meas-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

      echo "srcMatchFull" >>$WRITE/butler_stat-$NUM.txt
      echo "srcMatchFull"
      find $DIR1/deepCoadd-results/HSC-G/*/* -type f -name 'srcMatchFull-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-R/*/* -type f -name 'srcMatchFull-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-I/*/* -type f -name 'srcMatchFull-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Z/*/* -type f -name 'srcMatchFull-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Y/*/* -type f -name 'srcMatchFull-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

      echo "srcMatch" >>$WRITE/butler_stat-$NUM.txt
      echo "srcMatch"
      find $DIR1/deepCoadd-results/HSC-G/*/* -type f -name 'srcMatch-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-R/*/* -type f -name 'srcMatch-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-I/*/* -type f -name 'srcMatch-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Z/*/* -type f -name 'srcMatch-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt
      find $DIR1/deepCoadd-results/HSC-Y/*/* -type f -name 'srcMatch-*.fits' -exec du -c {} + | grep total$ >> $WRITE/butler_stat-$NUM.txt

    else
      echo "warp" >>$WRITE/butler_stat-$NUM.txt
      echo "warp"
      find $DIR1/deepCoadd/*/*/* -type f -name 'warp-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt
 
      echo "mergeDet" >>$WRITE/butler_stat-$NUM.txt
      echo "mergeDet"
      find $DIR1/deepCoadd-results/merged/*/* -type f -name 'mergeDet-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "ref" >>$WRITE/butler_stat-$NUM.txt
      echo "ref"
      find $DIR1/deepCoadd-results/merged/*/* -type f -name 'ref-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "calexp" >>$WRITE/butler_stat-$NUM.txt
      echo "calexp"
      find $DIR1/deepCoadd-results/[H,N]*/*/* -type f -name 'calexp-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "det_bkgd" >>$WRITE/butler_stat-$NUM.txt
      echo "det_bkgd"
      find $DIR1/deepCoadd-results/[H,N]*/*/* -type f -name 'det_bkgd-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "det" >>$WRITE/butler_stat-$NUM.txt
      echo "det"
      find $DIR1/deepCoadd-results/[H,N]*/*/* -type f -name 'det-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "forced_src" >>$WRITE/butler_stat-$NUM.txt
      echo "forced_src"
      find $DIR1/deepCoadd-results/[H,N]*/*/* -type f -name 'forced_src-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "meas" >>$WRITE/butler_stat-$NUM.txt
      echo "meas"
      find $DIR1/deepCoadd-results/[H,N]*/*/* -type f -name 'meas-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "srcMatchFull" >>$WRITE/butler_stat-$NUM.txt
      echo "srcMatchFull"
      find $DIR1/deepCoadd-results/[H,N]*/*/* -type f -name 'srcMatchFull-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

      echo "srcMatch" >>$WRITE/butler_stat-$NUM.txt
      echo "srcMatch"
      find $DIR1/deepCoadd-results/[H,N]*/*/* -type f -name 'srcMatch-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt
    fi 


    echo "fcr" >>$WRITE/butler_stat-$NUM.txt
    echo "fcr"
    find $DIR1/jointcal-results/* -type f -name 'fcr-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "wcs" >>$WRITE/butler_stat-$NUM.txt
    echo "wcs"
    find $DIR1/jointcal-results/* -type f -name 'wcs-*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "deepCoadd_det" >>$WRITE/butler_stat-$NUM.txt
    echo "deepCoadd_det"
    find $DIR1/schema -type f -name 'deepCoadd_d*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "deepCoadd_forced_src" >>$WRITE/butler_stat-$NUM.txt
    echo "deepCoadd_forced_src"
    find $DIR1/schema -type f -name 'deepCoadd_f*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "deepCoadd_meas" >>$WRITE/butler_stat-$NUM.txt
    echo "deepCoadd_meas"
    find $DIR1/schema -type f -name 'deepCoadd_mea*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "deepCoadd_mergeDet" >>$WRITE/butler_stat-$NUM.txt
    echo "deepCoadd_mergeDet"
    find $DIR1/schema -type f -name 'deepCoadd_mer*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "deepCoadd_peak" >>$WRITE/butler_stat-$NUM.txt
    echo "deepCoadd_peak"
    find $DIR1/schema -type f -name 'deepCoadd_p*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "deepCoadd_ref" >>$WRITE/butler_stat-$NUM.txt
    echo "deepCoadd_ref"
    find $DIR1/schema -type f -name 'deepCoadd_r*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

    echo "forced_src_schema" >>$WRITE/butler_stat-$NUM.txt
    echo "forced_src_schema"
    find $DIR1/schema -type f -name 'forced*.fits' -print0 |xargs -r0 du -a |awk '{sum+=$1} END {print sum}' >> $WRITE/butler_stat-$NUM.txt

  fi
  
done
