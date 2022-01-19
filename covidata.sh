#!/bin/bash
#Ziming Dong  Student ID: 260951177

errorMsg(){
	echo "Erro:$1"
	echo -e "Script syntax:\n ./covidata.sh -r ptocedure id range inputFile outputFile compareFile"
	echo -e "Legal usage examples:\n ./covidata.sh get 35 data.csv result.csv\n ./covidata.sh -r get 35 2020-01 2020-03 data.csv result.csv\n ./covidata.sh compare 10 data.csv result2.csv result.csv\n ./covidata.sh -r compare 10 2020-01 2020-03 data.csv result2.csv result.csv"
}
get(){
	rm -f $3
	awk -v id="$1" -v outputFile="$3" 'BEGIN { FS="," } {if($1 == id) { print $0 >> outputFile }}' < $2
	rowcount=$(grep -c "" $3)

	awk -v count="$rowcount" -v outputFile="$3" 'BEGIN { FS=",";confirm=0;deaths=0;tests=0} {confirm += $6;deaths += $8;tests += $11} END {OFS=",";print "rowcount,avgconf,avgdeaths,avgtests" >> outputFile;print count,confirm/count,deaths/count,tests/count >> outputFile}' < $3

} 
compare(){
	get $1 $2 temp.csv
	rm -f $3
	head -n -2 temp.csv >> $3
	head -n -2 $4 >> $3
	tail -n 2 temp.csv >> $3
	tail -n 2 $4 >> $3
	rm temp.csv
	countA=$(tail -n 1 $3 | awk 'BEGIN {FS=","} {print $1}')
	confirmA=$(tail -n 1 $3 | awk 'BEGIN {FS=","} {print $2}')
	deathsA=$(tail -n 1 $3 | awk 'BEGIN {FS=","} {print $3}')
	testsA=$(tail -n 1 $3 | awk 'BEGIN {FS=","} {print $4}')
	countN=$(grep -c "" $3)
	awk -v totalN="$countN" -v couA="$countA" -v conA="$confirmA" -v deaA="$deathsA" -v tesA="$testsA" -v outputFile="$3"\
	       	'BEGIN { FS=",";count=0;confirm=0;deaths=0;tests=0} {if(NR == totalN-2){count=$1-couA;confirm=$2-conA;deaths=$3-deaA;tests=$4-tesA}}\
	       	END {OFS=",";print "diffcount,diffavgconf,diffavgdeath,diffavgtests" >> outputFile;print count,confirm,deaths,tests >> outputFile}' < $3
}
getR(){
	x="$2"
	y="$3"
	xyear=${x:0:4}
	yyear=${y:0:4}
	xmonth=${x:5:2}
	ymonth=${y:5:2}
	startDay="01"
	endDay="15"
	rm -f $5
	if [[ $xyear < $yyear ]]
	then
		while [ $xmonth -le 12 ]; do
                        awk -v id="$1" -v month="$xmonth" -v year="$xyear" -v startday="$startDay" -v endday="$endDay" -v temp="temp1.csv" 'BEGIN { FS="," }\
                                {if(($1 == id)&&(substr($5,1,4)==year)&&(substr($5,6,2)==month)&&(substr($5,9,2)>=startday)&&(substr($5,9,2)<=endday))\
                                        { print $0 >> temp }}' < $4
                        if [[ -f temp1.csv ]]
                        then

                                get $1 temp1.csv temp2.csv
                                cat temp1.csv  >> $5
                                rm -f temp1.csv
                                tail -n 1 temp2.csv >> temp3.csv
                                rm -f temp2.csv
                        else
                                echo "0,0,0,0" >> temp3.csv
                        fi

			
			if [ $startDay -eq "01" ]
                        then
                                startDay="16"
                                endDay="31"
                        elif [ $startDay -eq "16" ]
                        then
                                startDay="01"
                                endDay="15"

                                xmonth=$(expr $xmonth + 1)
                                if [ ${#xmonth} -lt 2 ]
                                then
                                        xmonth=0$xmonth
                                fi
                        fi
                done
		startDay="01"
		endDay="15"
		xmonth="01"
		while [ $xmonth -le $ymonth ]; do
                        awk -v id="$1" -v month="$xmonth" -v year="$yyear" -v startday="$startDay" -v endday="$endDay" -v temp="temp1.csv" 'BEGIN { FS="," }\
                                {if(($1 == id)&&(substr($5,1,4)==year)&&(substr($5,6,2)==month)&&(substr($5,9,2)>=startday)&&(substr($5,9,2)<=endday))\
               			{ print $0 >> temp }}' < $4
			if [[ -f temp1.csv ]]
			then
				
                       		get $1 temp1.csv temp2.csv
                     	 	cat temp1.csv  >> $5
                        	rm -f temp1.csv
                        	tail -n 1 temp2.csv >> temp3.csv
                        	rm -f temp2.csv
			else
				echo "0,0,0,0" >> temp3.csv
			fi
                        if [ $startDay -eq "01" ]
                        then
                                startDay="16"
                                endDay="31"
                        elif [ $startDay -eq "16" ]
                        then
                                startDay="01"
                                endDay="15"

                                xmonth=$(expr $xmonth + 1)
                                if [ ${#xmonth} -lt 2 ]
                                then
                                        xmonth=0$xmonth
                                fi
                        fi
                done
		echo "rowcount,avgconf,avgdeaths,avgtests" >> $5
                cat temp3.csv >> $5
                rm -f temp3.csv

	elif [[ $xyear == $yyear ]]
	then
		while [ $xmonth -le $ymonth ]; do
			awk -v id="$1" -v month="$xmonth" -v year="$xyear" -v startday="$startDay" -v endday="$endDay" -v temp="temp1.csv" 'BEGIN { FS="," }\
				{if(($1 == id)&&(substr($5,1,4)==year)&&(substr($5,6,2)==month)&&(substr($5,9,2)>=startday)&&(substr($5,9,2)<=endday))\
					{ print $0 >> temp }}' < $4
			if [[ -f temp1.csv ]]
                        then

                                get $1 temp1.csv temp2.csv
                                cat temp1.csv  >> $5
                                rm -f temp1.csv
                                tail -n 1 temp2.csv >> temp3.csv
                                rm -f temp2.csv
                        else
                                echo "0,0,0,0" >> temp3.csv
                        fi

			if [ $startDay -eq "01" ]
			then
				startDay="16"
				endDay="31"
			elif [ $startDay -eq "16" ]
			then
				startDay="01"
				endDay="15"

				xmonth=$(expr $xmonth + 1)
				if [ ${#xmonth} -lt 2 ]
				then
					xmonth=0$xmonth
				fi
			fi
		done
		echo "rowcount,avgconf,avgdeaths,avgtests" >> $5
		cat temp3.csv >> $5
		rm -f temp3.csv
	fi

	
}
compareR(){
	x="$2"
        y="$3"
        xyear=${x:0:4}
        yyear=${y:0:4}
        xmonth=${x:5:2}
        ymonth=${y:5:2}
	rm -f $5
	if [[ $xyear == $yyear ]]
	then
		rowcount=$(($ymonth-$xmonth+1))
		rowcountA=$(($rowcount+$rowcount+1))
	else
		ymonth=$(($ymonth+12))
		rowcount=$(($ymonth-$xmonth+1))
                rowcountA=$(($rowcount+$rowcount+1))
	fi
	getR $1 $2 $3 $4 temp11.csv
	rowcountB=$((0-$rowcountA))
	head -n $rowcountB temp11.csv >> $5
	tail -n $rowcountA temp11.csv >> temp12.csv
	head -n $rowcountB $6 >> $5
	tail -n $rowcountA $6 >> temp13.csv
	cat temp12.csv >> $5
	cat temp13.csv >> $5
	rm -f temp11.csv
	echo "diffcount,diffavgconf,diffavgdeath,diffavgtests" >> $5
	for ((i=2;i<=$rowcountA;i=i+1))
	do
		awk -v num=$i -v temp="temp14.csv"  '{ if(NR == num) { print $0 >> temp }}' < temp12.csv
		awk -v num=$i -v temp="temp15.csv"  '{ if(NR == num) { print $0 >> temp }}' < temp13.csv
		countA=$(tail -n 1 temp15.csv | awk 'BEGIN {FS=","} {print $1}')
	        confirmA=$(tail -n 1 temp15.csv | awk 'BEGIN {FS=","} {print $2}')
        	deathsA=$(tail -n 1 temp15.csv | awk 'BEGIN {FS=","} {print $3}')
      	  	testsA=$(tail -n 1 temp15.csv | awk 'BEGIN {FS=","} {print $4}')
        	awk -v couA="$countA" -v conA="$confirmA" -v deaA="$deathsA" -v tesA="$testsA" -v outputFile="$5"\
                'BEGIN { FS=",";count=0;confirm=0;deaths=0;tests=0} {count=$1-couA;confirm=$2-conA;deaths=$3-deaA;tests=$4-tesA}\
                END {OFS=",";print count,confirm,deaths,tests >> outputFile}' < temp14.csv
		rm -f temp14.csv
		rm -f temp15.csv
	done
	rm -f temp12.csv
	rm -f temp13.csv
}
 
if [[ "$1" == "-r" ]]
then
	if [[ "$2" == "get" ]]
	then
		if [[ "$#" -eq 7 ]]
		then
			getR $3 $4 $5 $6 $7
		else
			errorMsg "Wrong number of arguments"
			exit 1
		fi
	elif [[ "$2" == "compare" ]]
	then
		if [[ "$#" -eq 8 ]]
		then
			compareR $3 $4 $5 $6 $7 $8
		else
			errorMsg "Wrong number of arguments"
			exit 1
		fi
	else
		errorMsg "Procedure not provided"
		exit 1

	fi

elif [[ "$1" == "get" ]]
then
	if [[ "$#" -eq 4 ]]
	then
		get $2 $3 $4 $5 $6
	else
		errorMsg "Wrong number of arguments"
		exit 1
	fi
elif [[ "$1" == "compare" ]]
then
	if [[ "$#" -eq 5 ]]
	then
		compare $2 $3 $4 $5 $6 $7
	else
		errorMsg "Wrong number of arguments"
		exit 1
	fi
else
	errorMsg "Procedure not provided"
	exit 1
fi


