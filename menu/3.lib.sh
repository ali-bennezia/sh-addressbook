# Remove entries
# 0

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
	echo "== Remove entries =="

	echo "Enter search queries to narrow down the results for the entry you would like to remove. (CTRL+C for menu, c to clear search queries)"

	while [ $BREAK -ne 1 ]
	do
		display_search_results

		if [ $RESCOUNT -eq 1 ]; then
			echo "Would you like to remove this record ? (y/n) (CTRL+C for menu)"

			read REMINPUT

			while [ $BREAK -ne 1 ]
			do
				[ $BREAK -eq 1 ] && BREAK=0 && return 0
				if [ "$REMINPUT" = "y" ]; then
					sed -i "/$RESULTS/d" ${SROOT}data
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
		[ $BREAK -eq 1 ] && BREAK=0 && return 0
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
