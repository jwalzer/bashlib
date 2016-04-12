[ "$INCLUDED_ASSERT" == "$RUNTOKEN" ] && return
INCLUDED_ASSERT="$RUNTOKEN"

INCLUDE "logging"
INCLUDE "functions"

DEBUG "Loading ${BASH_SOURCE[0]}"

ASSERT_LOG() {
	LOG "[ASSERT][<${FUNCNAME[2]}()>${BASH_SOURCE[2]}:${BASH_LINENO[2]}] Assertion Failed: $*"
}

ASSERT_ISINTEGER() {
	[[ "$*" -eq "$*" ]] || ( ASSERT_LOG "Is Integer: $*" ; return 1 )
}

ASSERT_EQ() {
	[[ "$1" == "$2" ]] || ( ASSERT_LOG "'$1' == '$2'" ; return 1 )
}

ASSERT_NEQ() {
	[[ "$1" != "$2" ]] || ( ASSERT_LOG "'$1' != '$2'" ; return 1 )
}

ASSERT_LT() {
	[[ "$1" -lt "$2" ]] || ( ASSERT_LOG "'$1' < '$2'" ; return 1 )
}

ASSERT_GT() {
	[[ "$1" -gt "$2" ]] || ( ASSERT_LOG "'$1' > '$2'" ; return 1 )
}

ASSERT_LE() {
	[[ "$1" -le "$2" ]] || ( ASSERT_LOG "'$1' < '$2'" ; return 1 )
}

ASSERT_GE() {
	[[ "$1" -ge "$2" ]] || ( ASSERT_LOG "'$1' > '$2'" ; return 1 )
}

ASSERT_EMPTY() {
	[[ -z "$*" ]] || ( ASSERT_LOG "String not Empty: '$*'" ; return 1 )
}

ASSERT_NOTEMPTY() {
	[[ -n "$*" ]] || ( ASSERT_LOG "String Empty" ; return 1 )
}

ASSERT_FILE() {
	ASSERT_NOTEMPTY "$*" || return 1
	[[ -e "$*" ]] || ( ASSERT_LOG "No File: $1" ; return 1 )
}

ASSERT_EXEC() {
	ASSERT_FILE "$*" || return 1
	[[ -x "$*" ]] || ( ASSERT_LOG "No File: $1" ; return 1 )
}


