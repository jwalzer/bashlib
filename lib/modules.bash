[ "$INCLUDED_MODULES" == "$RUNTOKEN" ] && return
INCLUDED_MODULES="$RUNTOKEN"

INCLUDE "logging"
INCLUDE "prereqs"

DEBUG "Loading ${BASH_SOURCE[0]}"

[[ -z "$MODULES_DIR" ]] && MODULES_DIR="$BASHLIB_MODULES_DIR"
[[ -z "$MODULES_DIR" ]] && MODULES_DIR="$LIBDIR/modules"

GET_MODULES() {
	DEBUG
	find "$MODULES_DIR" -maxdepth 1 -name "*.bash" -exec basename {} .bash \;
}

LOAD_MODULE() {
	DEBUG "$*"
	[ -r "$MODULES_DIR/${1}.bash" ] || FAIL "Can't read Module $1"
	. "$MODULES_DIR/${1}.bash" || FAIL "Problem on Loading Module $1"
}

LOAD_ALL_MODULES() {
	DEBUG "$*"
	for M in $(GET_MODULES)
		do
			DEBUG "Found Module $M"
			LOAD_MODULE "$M"
		done
}