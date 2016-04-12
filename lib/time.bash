[ "$INCLUDED_TIME" == "$RUNTOKEN" ] && return
INCLUDED_TIME="$RUNTOKEN"

INCLUDE "logging"
INCLUDE "assert"

DEBUG "Loading ${BASH_SOURCE[0]}"

GET_TIMESTAMP() {
	date +%s.%N
}

GET_DATETIMESTR() {
	date -u +%Y%m%d%H%M%S
}

CONV_2DATETIMESTR() {
	DEBUG "$@"
	ASSERT_NOTEMPTY "$1" || FAIL 99

	date -d "$1" +%Y%m%d%H%M%S
}

CONV_DTSTR2DATE() {
	ASSERT_NOTEMPTY "$1" || FAIL 99
	 sed -r 's#(.{4})(.{2})(.{2})(.{2})(.{2})#\1-\2-\3 \4:\5:#' <<< "$1"
}

CONV_DTSTR2TS() {
	ASSERT_NOTEMPTY "$1" || FAIL 99
	date -d "$(CONV_DTSTR2DATE "$1")" +%s.%N 
}
