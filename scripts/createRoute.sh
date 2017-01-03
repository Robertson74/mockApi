#!/bin/bash
############################## Initialize
routeDataFile=../data/activeRoutes.txt
mockApiServerFile=../servers/mockApiServer.js
############################## Insert route into server file
line=$1
echo $line
methodFirstHalf=$(echo $line | sed "s/^.*app\.//")
method=$(echo $methodFirstHalf | sed "s/('.*//")
routeFirstHalf=$(echo $line | sed "s/^.*app\.\(get\|post\)(//")
route=$(echo $routeFirstHalf | sed "s/, fun.*//")
returnDataFirstHalf=$(echo $line | sed "s/^.*send(//")
returnData=$(echo $returnDataFirstHalf | sed "s/);\s})//")
echo $route
echo $method
echo $returnData
sed -i "2iReturn Data: $returnData" $routeDataFile
sed -i "2iMethod : $method" $routeDataFile
sed -i "2iRoute : $route" $routeDataFile
sed -i "2i-----------------------------------------------------" $routeDataFile
sed -i "2i\ " $routeDataFile
sed -i "7$1" $mockApiServerFile
