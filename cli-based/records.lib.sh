# Records library

# Takes in an IFS-formatted record, checks its presence in the data file.
# Args: the IFS-formatted record (all args)
# Returns 1 if yes, 0 otherwise.
does_record_exist()
{
	grep -q "^$*$" ${SROOT}data
	RESULT=$?
	if [ $RESULT -eq "0" ]; then
		return 1
	else 
		return 0
	fi
}

# Takes in a first name, a last name, and an IFS-formatted record, overwrites the record with given name with the IFS-formatted record in the data file.
# Args: first name, last name, IFS-formatted record
overwrite_record()
{
	is_name_in_records "$1" "$2"
	EXISTS=$?
	if [ $EXISTS -eq 1 ]; then
		sed -i "s/^$1:$2:.*$/$3/g" ${SROOT}data
	fi
}

# Takes in a first name and a last name, checks their presence in the data file.
# Args: first name, last name
# Returns 1 if yes, 0 otherwise.
is_name_in_records()
{
	while read line
	do
		FNAME=`echo $line | cut -d: -f1`
		LNAME=`echo $line | cut -d: -f2`
		if [ "$FNAME" = "$1" -a "$LNAME" = "$2" ]; then
			return 1
		fi
	done < ${SROOT}data
	return 0
}

# Adds a record.
# Args: first name, last name, email, address
add_record()
{
	FNAME="$1"
	LNAME="$2"
	EMAIL="$3"
	ADDR="$4"
	echo "${FNAME}:${LNAME}:${EMAIL}:${ADDR}" >> ${SROOT}data
}

# Adds a formated record.
# Args: the formated record
add_formated_record()
{
	FRECORD="$*"
	echo "$FRECORD" >> ${SROOT}data
}

# Removes a record.
# Args: the IFS-formatted record (all args)
remove_record()
{
	FRECORD="$*"
	sed "/$FRECORD/d" ${SROOT}data
}

# Unformats a record.
# Args: the record (all args)
# Echoes the unformatted record.
unformat_record()
{
	echo "$*" | tr ":" " "
}

# Search records.
# Args: keywords (all args)
# Echoes the results.
search_records()
{
	KEYWORDS="$*"

	FRECORDS=`grep "$KEYWORDS" ${SROOT}data`
	
	echo "$FRECORDS" | while read line
	do
		NAME="`echo $line | cut -d: -f1` `echo $line | cut -d: -f2`"
		echo "$NAME" | grep -q "$KEYWORDS"
		RESULT=$?
		if [ $RESULT -eq 0 ]; then
			uline=`unformat_record $line`
			echo "$uline"
		fi
	done

}
