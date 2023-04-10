# Search address book
# 0

. ./records.lib.sh

execute_option()
{
	clear
	echo "-- Search --"
	
	while [ $BREAK -ne 1 ]
	do
		echo -n "Search query (CTRL+C for menu) : "
		read INPUT

                if [ $BREAK -eq 1 ]; then
			BREAK=0
                	return 0;
                fi

		RESULTS=`search_records "$INPUT"`
		[ "$RESULTS" = "" ] && COUNT=0 || COUNT=`echo "$RESULTS" | wc -l | cut -d" " -f1`
		echo "-- Search results ($COUNT records) --"
		echo "$RESULTS"
		echo "--"
		read
		clear
	done
}
