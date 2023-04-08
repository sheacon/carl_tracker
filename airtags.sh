#!/bin/bash

#forked script from: github.com/icepick3000/AirtagAlex

#customize
proj_dir=~/Projects/airtag_tracker
copied_csv=location_history.csv
copied_items=items.data

#Start an infinite loop
while :
do


	echo "create a copy of the Items.data file to prevent changes while the script is running"
	cp -pr ~/Library/Caches/com.apple.findmy.fmipcore/Items.data $proj_dir/$copied_items

	echo "check if $copied_csv exists"
	if [ ! -f $proj_dir/$copied_csv ]
	then
	echo "$copied_csv does not exist, creating one"
	#Header for the CSV file (currently set up to append to the file)
	echo findmytime,tagname,serialnumber,locationlatitude,locationlongitude,locationtimestamp,address,\
		antennapower,batterystatus,locationpositiontype,locationverticalaccuracy,\
		locationhorizontalaccuracy,locationfloorlevel,locationaltitude,locationisinaccurate,locationisold,\
		locationfinished >> $proj_dir/$copied_csv
	fi


	echo "check how many airtags to process"
	airtagsnumber=`cat $proj_dir/$copied_items | jq ".[].serialNumber" | wc -l`
	echo "number of airtags to process: $airtagsnumber"
	airtagsnumber=`echo "$(($airtagsnumber-1))"`

	for j in $(seq 0 $airtagsnumber)
	do
	echo processing airtag number $j

	findmytime=`date +"%Y-%m-%d  %T"`

	tagname=`cat $proj_dir/$copied_items | jq ".[$j].name"`
	serialnumber=`cat $proj_dir/$copied_items | jq ".[$j].serialNumber"`
	antennapower=`cat $proj_dir/$copied_items | jq ".[$j].productType.productInformation.antennaPower"`
	batterystatus=`cat $proj_dir/$copied_items | jq ".[$j].batteryStatus"`
	locationpositiontype=`cat $proj_dir/$copied_items | jq ".[$j].location.positionType"`
	locationlatitude=`cat $proj_dir/$copied_items | jq ".[$j].location.latitude"`
	locationlongitude=`cat $proj_dir/$copied_items | jq ".[$j].location.longitude"`
	locationtimestamp=`cat $proj_dir/$copied_items | jq ".[$j].location.timeStamp"`
	locationverticalaccuracy=`cat $proj_dir/$copied_items | jq ".[$j].location.verticalAccuracy" | sed 's/null/0/g'`
	locationhorizontalaccuracy=`cat $proj_dir/$copied_items | jq ".[$j].location.horizontalAccuracy" | sed 's/null/0/g'`
	locationfloorlevel=`cat $proj_dir/$copied_items | jq ".[$j].location.floorlevel" | sed 's/null/0/g'`
	locationaltitude=`cat $proj_dir/$copied_items | jq ".[$j].location.altitude" | sed 's/null/0/g'`
	locationisinaccurate=`cat $proj_dir/$copied_items | jq ".[$j].location.isInaccurate" | awk '{ print "\""$0"\"" }'`
	locationisold=`cat $proj_dir/$copied_items | jq ".[$j].location.isOld" | awk '{ print "\""$0"\"" }' `
	locationfinished=`cat $proj_dir/$copied_items | jq ".[$j].location.locationFinished" | awk '{ print "\""$0"\"" }' `
	address=`cat $proj_dir/$copied_items | jq ".[$j].address.mapItemFullAddress"| sed 's/null/""/g'`
	

	echo "write the data to the $copied_csv file"

	echo $findmytime,$tagname,$serialnumber,$locationlatitude,$locationlongitude,$locationtimestamp,$address,\
	$antennapower,$batterystatus,$locationpositiontype,$locationverticalaccuracy,\
	$locationhorizontalaccuracy,$locationfloorlevel,$locationaltitude,$locationisinaccurate,$locationisold,\
	$locationfinished >> $proj_dir/$copied_csv


	done
	date
	echo "sleep for 60 seconds"
	sleep 60

done

