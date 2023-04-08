#!/bin/bash

# change working dir to script location
cd "$(dirname "$0")"

# customize
proj_dir=.
copied_csv=location_history.csv
copied_items=items.tmp
interval_seconds="${1:-60}" # first argument, or default 60

# prevent system sleep
caffeinate -w $$ &

# infinite loop
while :
do

	# create a temporary copy Items.data to for processing
	cp -pr ~/Library/Caches/com.apple.findmy.fmipcore/Items.data $proj_dir/$copied_items

	# check if $copied_csv exists
	if [ ! -f $proj_dir/$copied_csv ]
	then
	# create $copied_csv if not exists
	# header
	echo findmytime,tagname,serialnumber,locationlatitude,locationlongitude,locationtimestamp,address,\
		antennapower,batterystatus,locationpositiontype,locationverticalaccuracy,\
		locationhorizontalaccuracy,locationfloorlevel,locationaltitude,locationisinaccurate,locationisold,\
		locationfinished >> $proj_dir/$copied_csv
	fi

	date
	# number of airtag items
	airtagsnumber=`cat $proj_dir/$copied_items | jq ".[].serialNumber" | wc -l`
	echo "number of airtags to process: $airtagsnumber"
	airtagsnumber=`echo "$(($airtagsnumber-1))"`

	for j in $(seq 0 $airtagsnumber)
	do

	#################################
	# fields pulled from Items.data #
	#################################

	# timestamps
	findmytime=`date +"%Y-%m-%d  %T"`
	locationtimestamp=`cat $proj_dir/$copied_items | jq ".[$j].location.timeStamp"`

	# tag info and location
	tagname=`cat $proj_dir/$copied_items | jq ".[$j].name"`
	serialnumber=`cat $proj_dir/$copied_items | jq ".[$j].serialNumber"`
	locationpositiontype=`cat $proj_dir/$copied_items | jq ".[$j].location.positionType"`
	locationlatitude=`cat $proj_dir/$copied_items | jq ".[$j].location.latitude"`
	locationlongitude=`cat $proj_dir/$copied_items | jq ".[$j].location.longitude"`
	address=`cat $proj_dir/$copied_items | jq ".[$j].address.mapItemFullAddress"| sed 's/null/""/g'`

	# status
	antennapower=`cat $proj_dir/$copied_items | jq ".[$j].productType.productInformation.antennaPower"`
	batterystatus=`cat $proj_dir/$copied_items | jq ".[$j].batteryStatus"`

	# accuracy and elevation
	locationverticalaccuracy=`cat $proj_dir/$copied_items | jq ".[$j].location.verticalAccuracy" | sed 's/null/0/g'`
	locationhorizontalaccuracy=`cat $proj_dir/$copied_items | jq ".[$j].location.horizontalAccuracy" | sed 's/null/0/g'`
	locationfloorlevel=`cat $proj_dir/$copied_items | jq ".[$j].location.floorlevel" | sed 's/null/0/g'`
	locationaltitude=`cat $proj_dir/$copied_items | jq ".[$j].location.altitude" | sed 's/null/0/g'`

	# flags
	locationisinaccurate=`cat $proj_dir/$copied_items | jq ".[$j].location.isInaccurate" | awk '{ print "\""$0"\"" }'`
	locationisold=`cat $proj_dir/$copied_items | jq ".[$j].location.isOld" | awk '{ print "\""$0"\"" }' `
	locationfinished=`cat $proj_dir/$copied_items | jq ".[$j].location.locationFinished" | awk '{ print "\""$0"\"" }' `

	#################################

	# record
	echo $findmytime,$tagname,$serialnumber,$locationlatitude,$locationlongitude,$locationtimestamp,$address,\
	$antennapower,$batterystatus,$locationpositiontype,$locationverticalaccuracy,\
	$locationhorizontalaccuracy,$locationfloorlevel,$locationaltitude,$locationisinaccurate,$locationisold,\
	$locationfinished >> $proj_dir/$copied_csv

	done

	echo "data written to $copied_csv"
	echo "wait $interval_seconds seconds to record again"
	sleep $interval_seconds

done

