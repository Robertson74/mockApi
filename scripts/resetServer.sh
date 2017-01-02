#!/bin/bash
rm ./mockApiServer.js
cp ../backups/CLEAN_mockApiServer.js ../servers/mockApiServer.js
rm ../data/activeRoutes.txt
touch ../data/activeRoutes.txt
