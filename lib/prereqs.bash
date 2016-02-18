[ "$INCLUDED_PREREQS" == "$RUNTOKEN" ] && return
INCLUDED_PREREQS="$RUNTOKEN"

INCLUDE "functions"

DEBUG "Loading ${BASH_SOURCE[0]}"

PREREQS=" ";
CHECKED_PREREQS=" "

PREREQ_REGISTER() {
	while [[ -n $1 ]]
		do
			DEBUG "Registering Prerequisite $1"
			STR_CONTAINS "$1" "$PREREQS" || PREREQS=" $1 $PREREQS"
			STR_CONTAINS "$1" "$CHECK_PREREQS" && CHECKED_PREREQS="${CHECKED_PREREQS// $1/}"
			shift
		done
}

CHECK_PREREQS() {
	for I in $PREREQS
		do
				DEBUG "Checking Prerequisite $I"
				$I || FAIL "Failure on Prerequisite: $I"
				STR_CONTAINS "$I" "$CHECK_PREREQS" || CHECKED_PREREQS=" $1 $CHECKED_PREREQS"
		done
}
