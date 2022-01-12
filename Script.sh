#!/bin/bash

func1 () {
    for myFile in "$1"/*; do
        if [ -d "$myFile" ]; then
            func1 "$myFile"
        else
            case $(file --mime-type -b "$myFile") in
                application/gzip) 
                    echo "gunzip    $myFile" ;;
                application/x-bzip2)
                    echo "bunzip2    $myFile" ;;
                application/zip)
                    echo "unzip    $myFile" ;;
                application/ncompress)
                    echo "uncompress    $myFile" ;; # NOT WORKING
                text/plain)
                    echo "text"    $myFile ;;
                *)
            esac
        echo ""

        fi
    done
}

START="./Myfolder"
func1 "$START"