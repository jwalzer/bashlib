[ "$INCLUDED_LOGGING" == "$RUNTOKEN" ] && return
INCLUDED_LOGGING="$RUNTOKEN"

echo "[DEBUG] Loading ${BASH_SOURCE[0]}" >&2
LOGTIMESTAMPFMT="%s.%N"

TS() {
	date "+$LOGTIMESTAMPFMT"
}

DEBUG() {
    [[ -n "$BASHLIB_DEBUG" ]] && echo "[$(TS)]$(GET_STACKSTR) $*"  > /dev/stderr
}

DEBUG_STREAM() {
	while read L
		do
    		DEBUG "$L"
    	done
}

PRQ() {
	DEBUG "[PREREQ] $*"
}

ERR_MSG() {
        echo "[ERROR] $*"  > /dev/stderr
}

ERR() {
        ERR_MSG "$*"
        ERR_MSG "Stacktrace follows"
        GET_STACKTRACE > /dev/stderr
        return 1
}

ERR_STREAM() {
		while read L
			do
        		ERR_MSG "$L"
        	done
        ERR_MSG "Stacktrace follows"
        GET_STACKTRACE > /dev/stderr
        return 1
}

GET_STACKSTR() {
	# to avoid noise we start with 1 to skip get_stack caller
	local RET=""
	local I
	local SSIZE=${#FUNCNAME[1]}
	for (( I=SSIZE; I > 0; I-- ))
		do
			local FN="${FUNCNAME[$I]}"
			[ -z "$FN" ] && FN="<undef>"
			RET="${RET}[${FN}]"
		done
	echo "$RET"
}

GET_STACKTRACE() {
	# to avoid noise we start with 1 to skip get_stack caller
	local I
	local SSIZE=${#FUNCNAME[1]}
	for (( I=1; I < SSIZE + 2; I++ ))
		do
			local FN="${FUNCNAME[$I]}"
			[ -z "$FN" ] && FN=MAIN
			local LNR="${BASH_LINENO[(( I - 1 ))]}"
			local SRCF="${BASH_SOURCE[$I]}"
			[ -z "$SRCF" ] && SRCF="<undef>"

			echo "in  ${FN}() ${SRCF}:${LNR}"
		done
}

LOG() {
    echo "[$(TS)][LOG] $*"
}

LOGN() {
    echo -n "[$(TS)][LOG] $*"
}


LOG_STREAM() {
	while read L
		do
    		LOG "$L"
    	done
}
