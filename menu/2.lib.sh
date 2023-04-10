# Add entries

flush_record()
{
	add_formated_record "$1"
	echo "Record added."
}

execute_option()
{
	echo "== Add entries =="
	echo "Enter data for the new entry (CTRL+C for menu)"
	while [ $BREAK -ne 1 ]
	do
		ARECORD=""
		for item in "First name" "Last name" "Address"
		do
			echo -n "`echo $item` : "
			read INPUT
			[ "$BREAK" -eq 1 ] && BREAK=0 && return 0

			ARECORD="${ARECORD}${INPUT}:"
		done
		ARECORD=`echo "$ARECORD" | sed s/.$//`

		FNAME=`echo "$ARECORD" | cut -d: -f1`
		LNAME=`echo "$ARECORD" | cut -d: -f2`
		is_name_in_records "$FNAME" "$LNAME"
		NAMEEXISTS="$?"

		if [ $NAMEEXISTS -eq 0 ]; then
			flush_record "$ARECORD"
		else
			while [ "$CHOICE" != "y" -a "$CHOICE" != "n" -a $BREAK -ne 1 ]
			do
				echo "The given name is already present in the records. Would you like to overwrite the existent one ? (y/n) (CTRL+C for menu)"
				read CHOICE
				[ "$BREAK" -eq 1 ] && BREAK=0 && return 0
			done
			if [ "$CHOICE" = "n" ]; then
				flush_record "$ARECORD"
			else
				overwrite_record "$FNAME" "$LNAME" "$ARECORD"
				echo "Record overwritten."
			fi

		fi

	done

}
