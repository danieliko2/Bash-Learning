#! /bin/bash


checkopts () { # getopts example
re='^[0-9]+$'
while getopts ":c:t:u:" opt; do # check string!@!
  case "${opt}" in
    c ) c=true

      C=${OPTARG}
      if ! [[ $C =~ $re ]] ; then
        echo "error: $C is not a number" >&2; exit 1
      fi
      ;;
    t ) t=true
      T=${OPTARG}
      ;;
    u ) u=true
      U=${OPTARG}
      ECHO "USERNAME: $U"
      ;;
    \? ) echo "Input is: [-c (num)] [-t (num)] [-u (num)] [Program Name]"
        exit
      ;;
  esac
done
}

checkinput () {
  if [ $XC = "-c" ] || [ $XC = "-t" ] || [ $XC = "-u" ] || [ $XC = "" ] || [[ $XC =~ ^[+-]?[0-9]+$ ]]
  then
    echo "Input error, for help input -h"
    exit
  fi
}

echops () {
  COUNT2=$(ps aux | grep $1 | wc -l)
  # if [ $u ]
  #   COUNT2=$(ps aux | grep "$U   " | grep $1 | wc -l)
  #   then echo "Pinging $1 for $U: "
  # else
    echo "Pinging $1 for all users: "
  # fi

  echo "$1 has $COUNT2 instance(s).."
}

psping () {
  XC=${@: -1} # process input
  checkopts $@
  checkinput $@
  COUNT=1
  if [ $t ]
    then
      while [ 1 = 1 ]; do
        echops $XC
        sleep $T
        if [[ $c && $COUNT = $C ]]
        then
          exit
        fi
        COUNT=$(($COUNT + 1))
      done
  else
    while [ 1 = 1 ]; do
        echops $XC
        sleep 1
        if [[ $c && $COUNT = $C ]]
        then
          exit
        fi
        COUNT=$(($COUNT + 1))
    done
  fi
}

#echops $@

psping -h

# X="ABC"
# Z="22"
# Y=${#Z}
# echo ${X:0:Y}

# x=${ps aux | grep}