[ "$INCLUDED_CONFIG" == "$RUNTOKEN" ] && return
INCLUDED_CONFIG="$RUNTOKEN"

INCLUDE "logging"
INCLUDE "prereqs"

DEBUG "Loading ${BASH_SOURCE[0]}"

CONFIG_TRY_LOAD()
	{
		while [[ -n "$1" ]]
			do
				DEBUG "Trying Load: $1"
				[[ -r "$1" ]]  && CONFIG_LOAD "$1"
				shift;
			done
	}

CONFIG_LOAD()
	{
		DEBUG "Loading $*"
		. $*
	}

CONFIG_LOAD_BASHLIB_DEFAULTS()
	{
		true
	}

CONFIG_TRY_LOAD "/etc/bashlibrc" ~/.bashlibrc

PREREQ_REGISTER "CONFIG_LOAD_BASHLIB_DEFAULTS"