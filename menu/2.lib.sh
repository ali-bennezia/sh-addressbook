# Add entries

flush_record()
{
	add_formated_record "$1"
	echo "Record added."
}

execute_option()
{
	echo "== Add entries =="
	echo "q to exit, m to show menu"
	while :
	do
		ARECORD=""
		for item in "First name" "Last name" "Address"
		do
			echo -n "`echo $item` : "
			read INPUT
			if [ "$INPUT" = "q" ]; then
				exit
			elif [ "$INPUT" = "m" ]; then
				return 0;
			fi

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
			while [ "$CHOICE" != "y" -a "$CHOICE" != "n" ]
			do
				echo "The given name is already present in the records. Would you like to overwrite to existent one ? (y/n)"
				read CHOICE
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
