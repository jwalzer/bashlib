[ "$INCLUDED_FUNCTIONS" == "$RUNTOKEN" ] && return
INCLUDED_FUNCTIONS="$RUNTOKEN"
INCLUDE "logging"
DEBUG "Loading ${BASH_SOURCE[0]}"

FAIL() {
	ERR_STREAM <<EOT

========= ERROR =========
$*
EOT

	exit "$1"
}

STR_CONTAINS() {
	NEEDLE="$1"
	shift;
	HAYSTACK="$*"
	case "$HAYSTACK" in
		*${NEEDLE}*)
				return 0
			;;
		*)
				return 1
			;;
	esac
	FAIL "Unexpected: STR_CONTAINS ( '$NEEDLE' , '$HAYSTACK' ) "
}

declare -A MILESTONES

MILESTONE_ADD() {
	MILESTONES["$1"]="$(date)"
	DEBUG "MILESTONES: [ $(GET_MILESTONES) ] "
}

MILESTONE() {
	[[ -z "${MILESTONES["$1"]}" ]] && MILESTONE_ADD "$1"
	echo "${MILESTONES["$1"]}"
}

GET_MILESTONES() {
	echo "${!MILESTONES[*]}"
}

SLEEP() {
	[[ -z $2 ]] || LOGN "$2:"
	for I in $(seq 0 "$1")
		do
			sleep 1
			echo -n .
		done
	echo
}

LIB_DIRS="$LIBDIR"
LIBDIR_ADD() {
	STR_CONTAINS "$1" "$LIB_DIRS" || LIB_DIRS=" $1 $LIB_DIRS"
}

INCLUDE() {
#	BASHLIB_DEBUG="TRUE"
	DEBUG "$*"
	for LIBD in  $LIB_DIRS
		do
			if [ -r "$LIBD/${1}.bash" ]
				then
					DEBUG "Loading $1 from $LIBD"
					. "$LIBD/${1}.bash" || FAIL 1 "Major Failure, loading $1"
					return 0
				fi
		done
	FAIL 1 "can't find '$1' or not readable"
}
