[ "$INCLUDED_LOCAL" == "$RUNTOKEN" ] && return
INCLUDED_LOCAL="$RUNTOKEN"

INCLUDE "logging"
INCLUDE "prereqs"

DEBUG "Loading ${BASH_SOURCE[0]}"

EXEC() {
        DEBUG "$*"
        bash -c "$*"
        return $?
}

SUDO() {
        DEBUG "$*"
        EXEC "sudo bash -c '$*'"
}

PREREQS_LOCAL_SUDO() {
	PRQ "testing local sudo"
	SUDO "echo successful sudo local >/dev/null" || return 1
}

PREREQS_LOCAL_EXEC() {
	PRQ "testing local exec"
	EXEC "echo successful local >/dev/null" || return 1
}

PREREQ_REGISTER PREREQS_LOCAL_EXEC PREREQS_LOCAL_SUDO

