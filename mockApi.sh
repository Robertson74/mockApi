#!/bin/bash
# changeLine=`cat testLineFile.txt`
# changeCommand=$changeLine"i"
bodyKey[1]=testKey1
bodyValue[1]=\"testVal1\"
bodyKey[2]=testKey2
bodyValue[2]=\"testVal2\"
method=""
path=""
response=""
postDataDisplay=""
happyWithRoute=0
tryAgain=0
mainMenuChoice=0
paramNum=0
interfaceServer=http://localhost:3059

############################## Route state
printRouteState()
{
  echo ""
  echo ""
  echo -e "-----------------------------------------\nRoute        : $path \nMethod       : $method \nPost Data    : $postDataDisplay \nReturn Data  : $response\n-----------------------------------------"
  echo ""
}

############################## Main Menu
mainMenu() 
{
  validResponse=0

  while [[ $validResponse -eq 0 ]]
  do
    echo "What would you like to do"
    echo "1: Create a route"
    echo "2: See all routes (not implemented)"
    echo "3: Reset the mock server (not implemented)"
    echo "4: Exit"
    read mainMenuChoice
    if [[ $mainMenuChoice -eq 1 ]] || [[ $mainMenuChoice -eq 2 ]] || [[ $mainMenuChoice -eq 3 ]] || [[ $mainMenuChoice -eq 4 ]]
    then
      validResponse=1
    else
      clear
      read -n 1 -s -p "---Bad input, try again---"
      clear
    fi
  done
}

############################## route
askForRoute() 
{
  validResponse=0
  while [[ $validResponse -eq 0 ]]
  do
    echo "SET THE ROUTE"
    printRouteState
    echo "Enter route:"
    echo "e.g. /testroute/testing"
    read path
    if [[ $path =~ ^(\/[[:alnum:]]*)+$ ]]
    then
      validResponse=1
    else
      path=""
      clear
      echo "---Bad route, try again:---"
      read -n 1 -s -p "e.g. /testroute/testing"
      clear
    fi
  done
}


############################## Method
askForMethod()
{
  validResponse=0
  while [[ $validResponse -eq 0 ]]
  do
    echo "WHICH HTTP METHOD?"
    printRouteState
    echo "Enter Method:"
    # echo "Options: get | post"
    echo "Options: get (other methods coming soon)"
    read method
    if [[ $method =~ ^[Gg][Ee][Tt]$ ]]
    then
      method="get"
      validResponse=1
    # elif [[ $method =~ ^[Pp][Oo][Ss][Tt]$ ]]
    # then
    #   method="post"
    #   validResponse=1
    else
      method=""
      clear
      echo "Bad method, try again:"
      read -n 1 -s -p "e.g. /testroute/testing"
      clear
    fi
  done
}

############################## Post Data
askForPostData()
{
    echo "SET REQUIRED POST DATA"
    paramNum=-1
    while [[ $paramNum -lt 0 ]] || [[ $paramNum -gt 9 ]]
    do
        printRouteState
        echo ""
        echo "How many JSON body parameters to expect: "
        read paramNum
    if [[ $paramNum -gt 9 ]]
    then
        echo ""
        echo "Fuck you Jaytee"
        echo "Way too many parameters"
    fi
    if [[ $paramNum -lt 0 ]]
    then
        echo "Fuck you Jaytee"
        echo "Can't have negative number of parameters."
    fi
    done

    printRouteState
    echo "Construct JSON Parameters (Parentheses Not Need):"
    for ((i=1; i <= $paramNum; i++))
    do
        echo ""
        echo "Key Number $i:"
        read bodyKey[$i]
        echo "Value Number $i:"
        read bodyValue[$i]

        echo ""
        echo "Required JSON Object so far:"
        echo "{"
        for ((o=0; o < $i; o++))
        do
            echo "    \"${bodyKey[o+1]}\" : \"${bodyValue[o+1]}\""
        done
        echo "}"
    done
}

############################## Return Data
askForReturnData()
{
    echo "WHAT DATA SHOULD BE RETURNED"
    printRouteState
    echo "Enter Return Data:"
    read response
}

############################## Check if route is good
checkIfHappyWithRoute()
{
    validResponse=0
    echo "ARE YOU HAPPY!!?!?"
    printRouteState
    while [[ $validResponse -eq 0 ]]
    do
        echo "Are you happy with the above route?"
        echo "Options: Yes | No"
        read input
        if [[ $input =~ [Yy][Ee][Ss] ]] || [[ $input =~ [Yy] ]]
        then
            validResponse=1
            happyWithRoute=1
        elif [[ $input =~ [Nn][Oo] ]] || [[ $input =~ [Nn] ]]
        then
            validResponse=1
            happyWithRoute=0
        else
            clear
            printRouteState
            echo "Not a valid response, please try again:"
        fi
    done
}

############################## Composing SED command
composeSedCommand()
{
    # sedCommand="6i app.$method"
    sedCommand="i app.$method"
    sedCommand=$sedCommand"('$path', function (req, res) {"


    for ((i=0; i<$paramNum; i++))
        # for ((i=1; i<${#bodyKey[*]}; i++))
        # for i in "${bodyKey[@]}"
    do
        sedCommand=$sedCommand" if(!req.body.${bodyKey[i]}){res.send(\'no \'${bodyKey[i]}\' in JSON body\')}"
        sedCommand=$sedCommand" if(req.body.${bodyKey[i]} != ${bodyValue[i]}){res.send(\'Key \'${bodyKey[i]}\' is incorrect\')}"
    done

    sedCommand=$sedCommand" res.send($response); })"
    # sed -i "6i app.$method(\'$path\', function (req, res) { res.send($response); })\n" mockApiServer.js
}

############################## Welcome Message
printTryAgainMessage()
{
    clear
    echo "LET'S TRY AGAIN"
    echo ""
    echo ""
    read -n 1 -s -p "Press any key to continue..."
    clear
}
############################## Welcome Message
printWelcomeMessage()
{
    clear
    echo "Mock Route Generator!"
    echo ""
    echo ""
    read -n 1 -s -p "Press any key to continue..."
    clear
}

############################## Welcome Message
printGoodbyeMessage()
{
    echo ""
    echo ""
    read -n 1 -s -p "All done...Press any key to exit..."
}

############################## Clear Variables
clearRouteVariables()
{
    method=""
    path=""
    response=""
    postDataDisplay=""
}

############################## send the route
sendRoute()
{
    singleQuoteSedCommand=$(echo $sedCommand | sed "s/\"/'/g")
    jsonBody=$(echo { \"sedCommand\" : \"$singleQuoteSedCommand\" })
    echo ""
    curl -H "Content-Type: application/json" -X POST -d "$jsonBody" $interfaceServer"/createRoute"
    echo ""
}

############################## send the route
allDone()
{
  echo "ROUTE SUCCESSFULLY CREATED!"
  read -n 1 -s -p "Press any key to continue..."
}

################ Main Program
clear
while [[ mainMenuChoice -ne 4 ]]
do
  printWelcomeMessage
  mainMenu
  if [[ mainMenuChoice -eq 1 ]]
  then
    while [[ $happyWithRoute -eq 0 ]]
      do
      if [[ tryAgain -eq 1 ]]
      then
        printTryAgainMessage
      fi
      clearRouteVariables
      clear
      askForRoute
      clear
      askForMethod
      clear
      if [[ $method =~ post ]]
      then
        askForPostData
      else
        postDataDisplay="-----"
      fi
      clear
      askForReturnData
      clear
      checkIfHappyWithRoute
      if [[ $happyWithRoute -eq 0 ]]
      then
        tryAgain=1
      else
        echo "Creating Your Route"
        echo ""
      fi
    done
    composeSedCommand
    sendRoute
    allDone
  elif [[ mainMenuChoice -eq 2 ]]
  then
    echo "Not Implemented"
    read -n 1 -s -p "Press any key to continue..."
    clear
  elif [[ mainMenuChoice -eq 3 ]]
  then
    echo "Not Implemented"
    read -n 1 -s -p "Press any key to continue..."
    clear
  elif [[ mainMenuChoice -eq 4 ]]
  then
    clear
    echo "Have a nice day"
    echo "exiting..."
    echo "     @@@@@                                        @@@@@ "
    echo "    @@@@@@@                                      @@@@@@@"
    echo "    @@@@@@@           @@@@@@@@@@@@@@@            @@@@@@@"
    echo "     @@@@@@@@       @@@@@@@@@@@@@@@@@@@        @@@@@@@@ "
    echo "         @@@@@     @@@@@@@@@@@@@@@@@@@@@     @@@@@      "
    echo "           @@@@@  @@@@@@@@@@@@@@@@@@@@@@@  @@@@@        "
    echo "             @@  @@@@@@@@@@@@@@@@@@@@@@@@@  @@          "
    echo "                @@@@@@@    @@@@@@    @@@@@@             "
    echo "                @@@@@@      @@@@      @@@@@             "
    echo "                @@@@@@      @@@@      @@@@@             "
    echo "                 @@@@@@    @@@@@@    @@@@@              "
    echo "                  @@@@@@@@@@@  @@@@@@@@@@               "
    echo "                   @@@@@@@@@@  @@@@@@@@@                "
    echo "               @@   @@@@@@@@@@@@@@@@@   @@              "
    echo "               @@@@  @@@@ @ @ @ @ @@@@  @@@@            "
    echo "              @@@@@   @@@ @ @ @ @ @@@   @@@@@           "
    echo "            @@@@@      @@@@@@@@@@@@@      @@@@@         "
    echo "          @@@@          @@@@@@@@@@@          @@@@       "
    echo "       @@@@@              @@@@@@@              @@@@@    "
    echo "      @@@@@@@                                 @@@@@@@   "
    echo "       @@@@@                                   @@@@@    "
    echo ""
  fi
done
