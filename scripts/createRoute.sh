#!/bin/bash
############################## Insert route into server file
sed -i "7$1" ./mockApiServer.js
