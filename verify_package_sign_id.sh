#!/bin/bash

# License ....: GPLv3
# Dev ........: Waldirio M Pinheiro
# Date .......: 11/19/2024
# Purpose ....: Provide info that is not available yet on Satellite. Issue https://issues.redhat.com/browse/SAT-29067 created
#

# Testing the parameter, which should be the package name
if [ "$1" == "" ]; then
  echo "Please, call $0 <package_name>"
  echo "exiting ..."
  exit 1
else
  PACKAGE_NAME=$1
fi

# Setting some variables
TEMP_FILE="/tmp/pkg_file"
ART_PATH="/var/lib/pulp/media/artifact"

# Doing a DB query
echo "select name,version,release,\"pkgId\" from rpm_package where name = '$PACKAGE_NAME'" | su - postgres -c "psql pulpcore" > $TEMP_FILE

# Checking if the query brought us something
count=$(cat $TEMP_FILE | grep "(0 rows)" | wc -l)
if [ $count -eq 1 ]; then
  echo "No package found ..."
  echo "exiting ..."
  exit 1
fi

# Assuming we are here, we have something, then, let's create the header of out CSV file
OUTPUT="/tmp/result.csv"
echo "name,version,release,key_id,artifact_path" > $OUTPUT

# And now, time to parse the information
echo "Please, wait ..."
cat $TEMP_FILE | grep $PACKAGE_NAME | while read line
do
  name=$(echo $line | cut -d"|" -f1 | awk '{print $1}')
  version=$(echo $line | cut -d"|" -f2 | awk '{print $1}')
  release=$(echo $line | cut -d"|" -f3 | awk '{print $1}')
  folder=$(echo $line | cut -d"|" -f4 | awk '{print $1}' | cut -c 1,2)
  file=$(echo $line | cut -d"|" -f4 | awk '{print $1}' | cut -c 3-)

  #echo "PATH: $ART_PATH/$folder/$file"
  if [ -f $ART_PATH/$folder/$file ]; then
    #echo "The file is around"
    key_id=$(rpm -qp $ART_PATH/$folder/$file --qf "%{SIGPGP:pgpsig}\n" | grep -o Key.*)
    echo "$name,$version,$release,$key_id,$ART_PATH/$folder/$file" >> $OUTPUT
  else
    #echo "The file is NOT present! Probably ondemand repository and no way to get the sign key"
    echo "$name,$version,$release,NO_KEY,ARTIFACT_NOT_PRESENT_PROBABLY_ONDEMAND" >> $OUTPUT
  fi
done

# And let's check the results! Congrats!
echo "Please, check the $OUTPUT file"
