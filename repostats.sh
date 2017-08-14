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
DIR=(/project/hsc_rc/w_2017_27/DM-11273)  #(/datasets/hsc/repo/rerun/DM-10404/SFM /datasets/hsc/repo/rerun/DM-10404/DEEP /datasets/hsc/repo/rerun/DM-10404/UDEEP /datasets/hsc/repo/rerun/DM-10404/WIDE)

#YOU MUST SPECIFY WHERE YOU WANT TO SEND THE OUTPUT FILES
WRITE=/scratch/thrush/hsc_rc


for DIR1 in "${DIR[@]}" #iterating through the directories above
do
  cd $DIR1
  NUM="${DIR1##*/}" #allows me to differentiate between different output files
  
  ### GETTING THE NUMBER OF FILES IN EACH SUBDIR ###
  printf "$DIR1">>$WRITE/numfiles-$NUM.txt #prints the main directory above as the first line
  
  # The monster below goes into the directory we are in (cd'd to above), prints the subdirectory
  # we are exploring, counts the number of files in that subdirectory (including any folders that
  # it contains) and prints it.
  find -type d | while read -r dir; do printf "%s:\t" "$dir"; find "$dir" -type f | wc -l ; done >>$WRITE/numfiles-$NUM.txt

  ### GETTING SIZE OF DIRECTORY ###
  du -b --apparent-size $DIR1 -d 5 >>$WRITE/sizedir-$NUM.txt
  
  ### GETTING SIZE OF BUTLER DIRECTORIES
  # THIS IS NOW DONE WITH BUTLER_STATS.SH
#  if ["$DIR1" == "/datasets/hsc/repo/rerun/DM-10404/SFM"]; then 
#    find $DIR1/0*/*/corr -type f -name 'CORR-*.fits' -exec du -c {} + | grep total$ >> $WRITE/size_calexp-$NUM.txt
#  fi


  
  ### FINDING 2000 MOST MASSIVE FILES FOR EACH MAIN DIRECTORY ###
    # TO DO: MAYBE TAKE NOTE OF MOST MASSIVE TYPES IN SOME WAY?
  find . -type f -exec du -Sh {} + | sort -rh | head -n 2000 >> $WRITE/bigfiles-$NUM.txt

 ### 2000 LEAST MASSIVE FILES
  
  find . -type f -exec du -Sh {} + | sort -rh | tail -n 2000 >> $WRITE/smallfiles-$NUM.txt 

  ### FINDING THE AVERAGE OF THE FILE SIZES ###
    # TO DO: CONVERT TO HUMAN READABLE??
    # MAYBE DO THIS SUBDIR BY SUBDIR, THEN DOA TOTAL AVERAGE?

  ls -lR | gawk '{sum+= $5; n++;} END {print sum/n;}' >>$WRITE/stats-$NUM.txt

  ### FINDING THE NUMBER OF LARGE FILES TOTAL (equal to or over 1 megabyte, under 10 megabytes)  ###
  printf "0-1kb \n">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 0 && $5 < 1000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt

  printf "1-10kb \n ">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 1000 && $5 < 10000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt
  
  printf "10-100kb \n">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 10000 && $5 < 100000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt
  
  printf "100kb-1Mb \n">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 100000 && $5 < 1000000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt

  printf "1-10Mb \n">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 1000000 && $5 < 10000000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt

  printf "10-100Mb \n">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 10000000 && $5 < 100000000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt

  printf "100M-1Gb \n ">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 100000000 && $5 < 1000000000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt

  printf "Greater than or equal to 1Gb \n">>$WRITE/stats-$NUM.txt
  ls -lR | gawk '{if ($5 >= 1000000000)  m++} END {print m;}' >>$WRITE/stats-$NUM.txt

  ### FINDING THE NUMER OF SMALL FILES TOTAL ###
  ls -lR | gawk '{if ($5 < 1000000) z++} END {print z;}' >>$WRITE/stats-$NUM.txt

done
