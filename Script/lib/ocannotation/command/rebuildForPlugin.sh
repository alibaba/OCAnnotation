#!/bin/sh 
workspace=$1
if [ -z "$workspace" ]
then
    echo "workspace is null"
    exit 1
fi


cd $workspace
cd Annotation
sh ./clean.sh
sh ./build.sh
exit $?
