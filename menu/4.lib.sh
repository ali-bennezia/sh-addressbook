# Edit entries

QUERIES=""
RESULTS=""
RESCOUNT="0"

display_search_results()
{
	echo "== Search results =="
	if [ -z "$RESULTS" ]; then
		RESULTS=`grep "$QUERIES" ${SROOT}data`
	else
		RESULTS=`echo "$RESULTS" | grep "$QUERIES"`
	fi
	echo "$RESULTS"
	RESCOUNT=`echo "$RESULTS" | wc -l | cut -d" " -f1`
	echo "($RESCOUNT record(s) found)"
	echo "=="
}

execute_option()
{
	echo "== Edit entries =="

	echo "Enter search queries to narrow down the results for the entry you would like to edit. (CTRL+C for menu, c to clear search queries)"

	while [ $BREAK -ne 1 ]
	do
		display_search_results

		if [ $RESCOUNT -eq 1 ]; then
			echo "Would you like to edit this record ? (y/n) (CTRL+C for menu)"

			read REMINPUT
			[ $BREAK -eq 1 ] && BREAK=0 && return 0
			while [ $BREAK -ne 1 ]
			do
				if [ "$REMINPUT" = "y" ]; then
					echo "$RESULTS"

					NEWRECORD=""
					index=1
					for i in "First name" "Last name" "Email address" "Address"
					do
						DEFAULTVAL=`echo "$RESULTS" | cut -d: -f$index`
						echo -n "$i [ $DEFAULTVAL ] "
						read EDITVAL
						[ $BREAK -eq 1 ] && BREAK=0 && return 0
						if [ -z "$EDITVAL" ]; then
							NEWRECORD="${NEWRECORD}`echo "$RESULTS" | cut -d: -f$index`:"
							index=`expr $index + 1`
							continue
						else
							NEWRECORD="${NEWRECORD}${EDITVAL}:"
							index=`expr $index + 1`
						fi
					done
					
					NEWRECORD=`echo "$NEWRECORD" | sed s/.$//`
					sed -i "s/$RESULTS/$NEWRECORD/" ${SROOT}data	

					break
				elif [ "$REMINPUT" = "n" ]; then
					break
				fi
			done

			QUERIES=""
			RESULTS=""
			continue

		fi

		read QUERIES
		[ $BREAK -eq 1 ] && BREAK=0 && return 0
		if [ "$QUERIES" = "c" ]; then
			QUERIES=""
			RESULTS=""
		fi
		QUERIES="$QUERIES"
	done
}
