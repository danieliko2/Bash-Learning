#! /bin/bash


checkopts () { # getopts example
while getopts ":c:t:u:" opt; do
  case "${opt}" in
    c ) c=true
      C=${OPTARG}
      ;;
    t ) t=true
      T=${OPTARG}
      ;;
    u ) u=true
      U=${OPTARG}
      ;;
    \? ) echo "Options are: [-c] [-t] [-u]"
        exit
      ;;
  esac
done
}

psping () {
  COUNT=1
  if [ $t ]
    then
      while [ 1 = 1 ]; do
        echo "yes"
        sleep $T
        if [[ $c && $COUNT = $C ]]
        then
          exit
        fi
        COUNT=$(($COUNT + 1))
      done
  else
    while [ 1 = 1 ]; do
        echo "yes"
        sleep 1
        if [[ $c && $COUNT = $C ]]
        then
          exit
        fi
        COUNT=$(($COUNT + 1))
    done
  fi
}

X=2


checkopts $@
psping