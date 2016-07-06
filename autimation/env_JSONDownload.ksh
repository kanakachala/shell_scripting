#!/bin/ksh
#####################################################################################################
# Script Name   : Env_JSONDownload.ksh
# Script Author : Exilant Offshore ( on 4-Jan-2013 )
# Purpose       : Creates Json formated file which is alias for Rundeck Option Provider Plugin
# Usage         : sh Env_JSONDownload.ksh <fileName>
######################################################################################################
## Error Exit function
error_exit()
{
	echo "$*"
	echo "Function Error Exit Invoked, Exiting with Error Status 1"
	exit 1
}
	
if [ ! -s "$1" ]
then
	error_exit "ERROR: Script Usage sh Env_JSONDownload.ksh <fileName>"
fi

inputFile="$1"

JSON_Home=$HOME/Documents/shellScripting/autimation/JSON_FILES/merlin

\rm -f FileList.txt download.txt tmp

while read ifile
do
	## Setting Variables
	Maven_URL=$(echo $ifile | cut -d ' ' -f1)
	File_Type=$(echo $ifile | cut -d ' ' -f2)
	env_Name=$(echo $ifile | cut -d ' ' -f3)
	app_Name=$(echo $ifile | cut -d ' ' -f4)

	mkdir -p ${JSON_Home}/${env_Name}

	## Downloading the HTML Format of the give Maven URL
	echo "Downloading $Maven_URL"
	curl -ls "$Maven_URL" >download.txt
	if [ $? -ne 0 ]
	then
		error_exit "ERROR: Downloading HTML Format of given Maven URL Failed, Please check the Maven URL." 
	fi

	## Creating Value Pair file with  from the html file
	grep "${File_Type}<" download.txt > FileList.txt
	if [ $? -ne 0 ]
	then
		error_exit "ERROR: Mentioned File type is not available in the Maven Url, Please check Maven url and File Type." 
	fi

	lineCount=$(wc -l FileList.txt | awk '{print $1}')

	if [ $lineCount -ge 10 ]
	then
		tail -10 FileList.txt >tmp && mv tmp FileList.txt
		lineCount=10		
	fi
	
	tail -1 FileList.txt >tmp
	head -$(expr ${lineCount} - 1) FileList.txt >>tmp
	mv tmp FileList.txt
	
	## Loop creates json file
	echo "[" >Output.json
	
	while read line
	do
		Url=`echo $line | cut -d '"' -f2`
		Name=`echo $line | awk 'BEGIN { FS="<|>" } { print $3 }'`
		echo "{\"name\":\"${Name}\",\"value\":\"${Url}\"}," >>Output.json
	done < FileList.txt
	
	echo "]" >>Output.json
	##
	
	mv Output.json ${JSON_Home}/${env_Name}/${app_Name}.json
	echo "File created : `ls -l ${JSON_Home}/${env_Name}/${app_Name}.json`"
done < $inputFile
exit 0

