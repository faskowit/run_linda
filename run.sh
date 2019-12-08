#!/bin/bash

# helper func
function checkisfile {

	inFile=$1
	if [[ ! -f ${inFile} ]] ; then
		echo "file does not exist: $inFile"
		exit 1
	fi
}

# where we executing this?
EXEDIR=$(dirname "$(readlink -f "$0")")/

function help_prompt {
cat <<helptext
	USAGE ${0} 
		-f 		path to lesion brain
    -o    path to output dir
helptext
}

if [[ $# -lt 2 ]] ; then help_prompt ; exit 1 ; fi

# read in files
while [ "$1" != "" ]; do
    case $1 in
        -f | -func ) shift
                     fmriImg=$1
                     checkisfile $1
                     ;;
        -o | -out ) shift
								    oDir=$1
								    ;;
        * )         help_prompt
                    exit 1
    esac
    shift #this shift "moves up" the arg in after each case
done

# run it
cmd="Rscript run_linda.R ${fmriImg} ${oDir}"
echo $cmd
eval $cmd
