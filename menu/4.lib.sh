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

	echo "Enter search queries to narrow down the results for the entry you would like to edit. (q to exit, m to go to menu, c to clear search queries)"

	while :
	do
		display_search_results

		if [ $RESCOUNT -eq 1 ]; then
			echo "Would you like to edit this record ? (y/n) (q to exit, m to go to menu)"

			read REMINPUT
			while :
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
				elif [ "$REMINPUT" = "q" ]; then
					exit
				elif [ "$REMINPUT" = "m" ]; then
					return 0
				fi
			done

			QUERIES=""
			RESULTS=""
			continue

		fi

		read QUERIES
		if [ "$QUERIES" = "q" ]; then
			exit
		elif [ "$QUERIES" = "m" ]; then
			return 0
		elif [ "$QUERIES" = "c" ]; then
			QUERIES=""
			RESULTS=""
		fi
		QUERIES="$QUERIES"
	done
}
