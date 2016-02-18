export LC_ALL='C'

__TOKEN__="$$"
[ "$INCLUDED_INIT" == "$__TOKEN__" ] && return
RUNTOKEN="$__TOKEN__"
INCLUDED_INIT="$RUNTOKEN"

LIBDIR="/usr/local/lib/bashlib"

INCLUDE() {
	[ -r "$LIBDIR/${1}.bash" ] && . "$LIBDIR/${1}.bash"
}

for lib in functions logging
	do
		INCLUDE $lib
	done

true
