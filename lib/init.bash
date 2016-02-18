export LC_ALL='C'

LIBDIR="/usr/local/lib/bashlib"

__TOKEN__="$$"
[ "$INCLUDED_INIT" == "$__TOKEN__" ] && return
RUNTOKEN="$__TOKEN__"
INCLUDED_INIT="$RUNTOKEN"


#
# This is just a minimal bootstrapping version of INCLUDE()
# It will be overwritten by a version from functions.bash which
# is more sophisticated
#
INCLUDE() {
	if [ -r "$LIBDIR/${1}.bash" ]
		then
		 . "$LIBDIR/${1}.bash"
		 [[ "$?" -eq 0 ]] || echo "Major Failure, loading $1"
		 [[ "$?" -eq 0 ]] || exit 1
		else
			echo "can't find $1 or not readable"
			exit 1
		fi
}

for lib in config functions logging
	do
		INCLUDE $lib
	done

true