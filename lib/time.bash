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

DIFF_DATETIMESTR() {
	DEBUG "$@"
	ASSERT_ISINTEGER "$2" || FAIL 99

	D1="$(CONV_DTSTR2DATE $1)"
	D2="$(CONV_DTSTR2DATE $2)"
	D1sec=$(date -d "$D1" +%s)
	D2sec=$(date -d "$D2" +%s)

	DIFF="$(( D1sec - D2sec ))"

	DEBUG "D1 ($D1) - D2 ($D2) = D1sec ($D1sec) - D2sec ($D2sec) = DIFF ($DIFF) = $DIFF"

	echo "$DIFF"
}

CONV_SEC2TIME() {
	DEBUG "$@"
	ASSERT_ISINTEGER "$1" || FAIL 99

	SEC="$1"
	SGN=""
	RET=""

	if [[ "$SEC" -lt 0 ]]
		then
			SGN="-"
			SEC="$(( SEC * -1 ))"
		fi

	if [[ "$SEC" -gt 60 ]]
		then
			MIN="$(( SEC / 60 ))"
			SEC="$(( SEC % 60 ))"
		fi
	[[ "$SEC" -gt 0 ]] && RET="${SEC}s${RET}"

	if [[ "$MIN" -gt 60 ]]
		then
			HOUR="$(( MIN / 60 ))"
			MIN="$(( MIN % 60 ))"
		fi
	[[ "$MIN" -gt 0 ]] && RET="${MIN}m${RET}"

	if [[ "$HOUR" -gt 24 ]]
		then
			DAY="$(( HOUR / 24 ))"
			HOUR="$(( HOUR % 24 ))"
		fi
	[[ "$HOUR" -gt 0 ]] && RET="${HOUR}h${RET}"

	if [[ "$DAY" -gt 7 ]]
		then
			WEEK="$(( DAY / 7 ))"
			DAY="$(( DAY % 7 ))"
		fi
	[[ "$DAY" -gt 0 ]] && RET="${DAY}d ${RET}"
	[[ "$WEEK" -gt 0 ]] && RET="${WEEK}w${RET}"


	echo "$SGN$RET"
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
