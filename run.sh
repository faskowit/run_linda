#!/bin/bash

# default number of threads
ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8

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
        -f | -func )	shift
                     	fmriImg=$1
                     	checkisfile $1
                     	;;
        -o | -out ) 	shift
				    	oDir=$1
				    	;;
		-t | -threads ) shift
		# https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
						re='^[0-9]+$'
						if ! [[ $1 =~ $re ]] ; then
						   echo "-t not a number" >&2; exit 1
						else
							ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=$1
						fi
						;;
        * ) help_prompt
            exit 1
    esac
    shift #this shift "moves up" the arg in after each case
done

# export num threads to R script
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS

# run it
cmd="Rscript ${EXEDIR}/run_linda.R ${fmriImg} ${oDir}"
echo $cmd
eval $cmd
