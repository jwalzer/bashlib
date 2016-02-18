[ "$INCLUDED_REMOTE" == "$RUNTOKEN" ] && return
INCLUDED_REMOTE="$RUNTOKEN"

INCLUDE "logging"
INCLUDE "prereqs"
INCLUDE "functions"

DEBUG "Loading ${BASH_SOURCE[0]}"

PREREQ_REMOTE_HOSTS=""
PREREQ_REMOTE_SUDO=""

REMOTE_EXEC() {
        DEBUG "$*"
        DST=$1
        shift;
        ssh -A "$DST" "$*"
}

REMOTE_SUDO() {
        DEBUG "$*"
        DST=$1
        shift;
        REMOTE_EXEC "$DST" "sudo bash -c \"$*\""
}

REGISTER_PREREQ_REMOTE_SUDO() {
	while [[ -n "$1" ]]
		do
			STR_CONTAINS "$1" "$PREREQ_REMOTE_SUDO" || PREREQ_REMOTE_SUDO="$1 $PREREQ_REMOTE_SUDO"
			shift
		done
	REGISTER_PREREQ_REMOTE_HOSTS "$*"
}

REGISTER_PREREQ_REMOTE_HOSTS() {
	while [[ -n "$1" ]]
		do
			STR_CONTAINS "$1"  "$PREREQ_REMOTE_HOSTS" || PREREQ_REMOTE_HOSTS="$1 $PREREQ_REMOTE_HOSTS"
			shift
		done
}

CHECK_PREREQ_REMOTE_HOSTS() {
	for H in $PREREQ_REMOTE_HOSTS
		do
			PRQ "testing remote exec for $H"
			REMOTE_EXEC "$H" "echo Successful login on $H" || return 1
		done
}

CHECK_PREREQ_REMOTE_SUDO() {
	for H in $PREREQ_REMOTE_SUDO
		do
			PRQ "testing remote sudo for $H"
			REMOTE_SUDO "$H" "echo Successful login on $H" || return 1
		done
}

PREREQ_REGISTER CHECK_PREREQ_REMOTE_HOSTS CHECK_PREREQ_REMOTE_SUDO