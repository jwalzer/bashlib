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