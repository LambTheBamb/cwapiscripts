#!/bin/bash


read -p "Enter your CW mail:" cwemail

read -p "Enter your API Key:" apikey
read -p "status ( disable | enable)" statusz
arraysize=$(wc -l output| awk '{print $1}')

echo $arraysize

declare -a serverids
declare -a appids
#appids=("awk '{print $2}' output")

while IFS= read -r line; do
  #ids+=("$line")
    serverids+=($(echo "$line" | awk '{print $1}'))
    appids+=($(echo "$line" | awk '{print $2}'))
done < output

for (( i=0; i< $arraysize; ++i));

do
	#serverids=$(	${ids[$i]} | awk "{print $1}"	)
	tfatoken=$(curl -s -X POST --header 'Content-Type: application/x-www-form-urlencoded' --header 'Accept: application/json' -d "email=$cwemail&api_key=$apikey" 'https://api.cloudways.com/api/v1/oauth/access_token' | cut -d ":" -f 2 | cut -d '"' -f 2)
	echo "\n/n DISABLING APP ACCESS FOR SERVER ID: ${serverids[$i]} APP ID: ${appids[$i]} \n /n"

	curl -X POST --header 'Content-Type: application/x-www-form-urlencoded' --header "Authorization: Bearer $tfatoken" -d "server_id=${serverids[$i]}&app_id=${appids[$i]}&state=disable" 'https://api.cloudways.com/api/v1/app/state'

	sleep 6s
	echo "Status of ${appids[$i]}"
	curl -s -X GET --header 'Accept: application/json' --header "Authorization: Bearer $tfatoken" "https://api.cloudways.com/api/v1/app/getApplicationAccess?server_id=${serverids[$i]}&app_id=${appids[$i]}" 
echo "\n/n NEW APP IN PROGRESS/n \n"

done
