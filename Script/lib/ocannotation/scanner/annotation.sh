#!/bin/sh 

log_info ()
{
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	GREEN='\033[0;32m'
	NC='\033[0m' # No Color

	printf "${BLUE}${1}${NC}\n"
}
log_warning ()
{
	RED='\033[0;31m'
	BLUE='\033[0;33m'
	GREEN='\033[0;32m'
	NC='\033[0m' # No Color

	printf "${RED}${1}${NC}\n"
}
log_good ()
{
	RED='\033[0;31m'
	BLUE='\033[0;33m'
	GREEN='\033[0;32m'
	NC='\033[0m' # No Color

	printf "${GREEN}${1}${NC}\n"
}

locateWorkspace () {
	WORKSPACE=$1

	if [ -z "$WORKSPACE" ]
	then
		log_warning "workspace is null"
		exit 1
	fi

	ABSOLUTE_PATH="$(cd $WORKSPACE; pwd)"
	
	CURRENTDIR="$(pwd)"
        TARGET_WORKSPACE=$ABSOLUTE_PATH"/Annotation"	
	if [ "$CURRENTDIR" != "$TARGET_WORKSPACE" ]; then
		cd $TARGET_WORKSPACE
		log_info "relocating workspace to" "$(pwd)" 
	else
		echo 'workspace is '$CURRENTDIR
	fi
}

clean () {	
	WORKSPACE=$1
	locateWorkspace $WORKSPACE

	log_info "cleanning..."
	mkdir -p log
	logFilePath=./log/log.log

	rbfile=$WORKSPACE"/Annotation/buildAnnotation.rb"

	GEM_HOME=$WORKSPACE"/Annotation/gems" ruby $rbfile -c > ${logFilePath}

	echo "----------ruby log-------------\n"
	cat ${logFilePath}
	echo "-------------------------------\n"

	log_good "cleanning...done"
	echo ""
}

buildAnnotation () {
	WORKSPACE=$1
	locateWorkspace $WORKSPACE

	mkdir -p log
	logFilePath=./log/log.log

	rbfile=$WORKSPACE"/Annotation/buildAnnotation.rb"

	log_info "building...\n"
	GEM_HOME=$WORKSPACE"/Annotation/gems" ruby $rbfile -b > ${logFilePath}

	echo "----------ruby log-------------\n"
	cat ${logFilePath}
	echo "-------------------------------\n"

	log_good "buiding...done\n"
	
	exit 0
}

