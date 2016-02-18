[ "$INCLUDED_TIME" == "$RUNTOKEN" ] && return
INCLUDED_TIME="$RUNTOKEN"

INCLUDE "logging"

DEBUG "Loading ${BASH_SOURCE[0]}"

GET_TIMESTAMP() {
	date +%s.%N
}
