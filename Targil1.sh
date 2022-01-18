#!/bin/bash
main () {
    COUNT=0
    checkopts $@
    func8 $@
    echo ""
    echo "$COUNT file(s) decompressed"
}
decompress_2 () {
    FILENAME=${1##*/}
    case $(file --mime-type -b "$1") in
        application/gzip)
        # if [${1:-2} = "gz"]
        # then
            [[ $v ]] && echo "Extracting $FILENAME... "
            eval "gunzip -d -f '$1'"
            COUNT=$(($COUNT + 1))
        # fi
        ;;

        application/x-bzip2*)
         if [ ${1:(-4)} = ".bz2" ]
         then
            [[ $v ]] && echo "Extracting $FILENAME... "
            eval "bunzip2 -d -f '$1'" 
            COUNT=$(($COUNT + 1))
         else
            echo "$FILENAME was skipped"
        fi
        ;;

        application/zip)
        [[ $v ]] && echo "Extracting $FILENAME... ."
        COUNT=$(($COUNT + 1))
        eval "unzip -o -qq '$1'"
        eval "rm '$1'"
        ;;

        application/x-compress)
        FILENAME2=${1::-4}z
        mv "$1" "$FILENAME2"
        eval "uncompress -f $FILENAME2"
        [[ $v ]] && echo "Extracting $FILENAME... "
        COUNT=$(($COUNT + 1))
        ;;

        *)
            [[ $v ]] && echo "$FILENAME was skipped"
    esac

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
main $@

# X="ASD.BZ"
# if [ ${X:(-3)} = ".BZ" ]
# then echo "YES ${X:(-3)}"
# fi