#!/bin/bash

# filename = $0
# arguments num = $#
# arguments - ${1} ${2} ${3} ....

main () {
    COUNT=0
    checkopts $@
    func8 $@
    echo ""
    echo "$COUNT file(s) decompressed"
}
decompress () {
    case $(file --mime-type -b "$1") in
        application/gzip) 
            echo "gunzip    $1" ;;
        application/x-bzip2)
            echo "bunzip2    $1" ;;
        application/zip)
            echo "unzip    $1" ;;
        application/x-compress)
            echo "uncompress    $1" ;;
        text/plain)
            echo "text"    $1 ;;
        *)
    esac
}

decompress_2 () {
    FILENAME=${1##*/}
    case $(file --mime-type -b "$1") in
        application/gzip) 
        [[ $v ]] && echo "Extracting $FILENAME..."
        eval "gunzip -d -f '$1'"
        COUNT=$(($COUNT + 1))
        ;;

        application/x-bzip2)
        [[ $v ]] && echo "Extracting $FILENAME..."
        eval "bunzip2 -d -f '$1'" 
        COUNT=$(($COUNT + 1))
        ;;

        application/zip)
        [[ $v ]] && echo "Extracting $FILENAME..."
        COUNT=$(($COUNT + 1))
        eval "unzip -o -qq '$1'"
        eval "rm '$1'"
        ;;

        application/x-compress)
            [[ $v ]] && echo "Extracting $FILENAME..."
            COUNT=$(($COUNT + 1))
            ;;

        *)
            [[ $v ]] && echo "$FILENAME was skipped"
    esac

}

func1 () { # get zip types recursively
    for myFile in "$1"/*; do
        # echo $r
        FILENAME=${myFile##*/}
        if [[ -d "$myFile" && $r ]]; then # recursively if -r and dir
            # func1 "$myFile"
            echo "$myFile"
            func1 "$myFile"
        elif [ ! -d $myFile  ]
            then
            decompress_2 "$myFile"
          #   echo "decompressing $FILENAME"
        fi
    done
}


checkopts () { # getopts example
while getopts ":rv" opt; do
  case ${opt} in
    r ) r=true
      ;;
    v ) v=true
      ;;
    \? ) echo "Options are: [-r] [-v]"
        exit
      ;;
  esac
done
}

func3 () { # Loop through ARGS
    for var in "$@"
        do
            echo "$var"
        done
}

func4 () { # Find file passed through argument
        for var in "$@"; do
            for myFile in "$@"; do
                FILENAME=${myFile##*/}
                if [ "$var" == "$FILENAME" ]
                then
                    echo $var
                fi
            done
        done
}

func6 () {
    for VAR in "$@"; do
        if [ -d "$VAR" ] # Check if input is a directory
        then
            func1 $VAR
        else
            for myFile in *; do
                FILENAME=${myFile##*/}
                if [[ "$VAR" == "$FILENAME" && "$VAR" != "-r" && "$VAR" != "-t" ]]
                then
                    COUNT=$(($COUNT + 1))
                    decompress $VAR
                fi # add case file not found
            done
        fi
    done
    if [ $t ]
    then
        echo "$COUNT files"
    fi
}

func7 () {
    COUNT=0
    for VAR in "$@"; do
        if [ -d "$VAR" ] # Check if input is a directory
        then
            func1 $VAR
        else # if file
            decompress_2 $VAR
        fi
    done
    if [ $t ]
    then
        echo "$COUNT files"
    fi
}


func8 () {
    for VAR in "$@"; do
        if [ -d "$VAR" ] # Check if input is a directory
        then
            for myFile in "$VAR"/*; do
                # echo $r
                FILENAME=${myFile##*/}
                if [[ -d "$myFile" && $r ]]; then # recursively if -r and dir
                    # func1 "$myFile"
                    func8 "$myFile"
                elif [[ -f $myFile  ]]
                then
                    decompress_2 "$myFile"
                #   echo "decompressing $FILENAME"
                fi
            done
        else
            for myFile in "$PWD"/*; do
            FILENAME=${myFile##*/}
                if [[ -f "$myFile" && "$VAR" == "$FILENAME" ]]
                then
                    # echo "Decompressing $myFile"
                    decompress_2 "$myFile"
                fi
            done
        fi
    done

}
# START="./Myfolder"
# func1 "$START"

# COUNT=0
main $@

# [[ 1 = 2 ]] && echo "yes" || echo "no"

# if [[ -f $1 ]]
# then
#     echo "$1 is a file"
# fi
#echo "$PWD"/*
# X=1
# X=$(($X + 1))
# echo $X
