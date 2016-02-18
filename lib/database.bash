[ "$INCLUDED_DATABASE" == "$RUNTOKEN" ] && return
INCLUDED_DATABASE="$RUNTOKEN"

INCLUDE "logging"
INCLUDE "prereqs"
INCLUDE "functions"

DEBUG "Loading ${BASH_SOURCE[0]}"

PREREQ_REMOTE_DATABASES=""

MYSQL_TOKENIZE() {
	IFS=':@:/' read USER_ PW_ HOST_ PORT_ DB_ EOL_
	[[ -n "$EOL_" ]] && ERR "DB_CONNECT_STRING ambiguous: Not sure about '$EOL_'"
	[[ -z "$DB_" ]] && ERR "DB_CONNECT_STRING ambiguous: NO_DATABASENAME"
	[[ -z "$PORT_" ]] && ERR "DB_CONNECT_STRING ambiguous: NO_DATABASENPORT"
	[[ -z "$HOST_" ]] && ERR "DB_CONNECT_STRING ambiguous: NO_DATABASENHOST"
	[[ -z "$PW_" ]] && ERR "DB_CONNECT_STRING ambiguous: NO_DATABASEPASSWORD"
	[[ -z "$USER_" ]] && ERR "DB_CONNECT_STRING ambiguous: NO_DATABASEUSER"

	echo "mysql --host=$HOST_ --port=$PORT_ --user=$USER_ --password=$PW_ $DB_"
}

DB_EXEC() {
        DEBUG "$*"
        DST=$1
        shift;
        cat <<EOT | DB_EXEC_STREAM "$DST" | DEBUG_STREAM
$1
EOT
}

DB_EXEC_STREAM() {
        DEBUG "$*"
        DST=$1
        shift;
        MYSQL_EXEC="$(echo  "$DST" | MYSQL_TOKENIZE)"
        DEBUG "mysql_exec=<${MYSQL_EXEC}>"
        $MYSQL_EXEC
}

REGISTER_PREREQ_DATABASE() {
	while [[ -n "$1" ]]
		do
			STR_CONTAINS "$1" "$PREREQ_REMOTE_DATABASES" || PREREQ_REMOTE_DATABASES="$1 $PREREQ_REMOTE_DATABASES"
			shift
		done
}

CHECK_PREREQ_DATABASE() {
	for H in $PREREQ_REMOTE_DATABASES
		do
			PRQ "testing DB_CONNECT for $H"
			DB_EXEC "$H" "show tables;" || return 1
		done
}

PREREQ_REGISTER CHECK_PREREQ_DATABASE