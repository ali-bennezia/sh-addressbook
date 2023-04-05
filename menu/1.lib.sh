# Search address book

. ./records.lib.sh

execute_option()
{
	clear
	echo "-- Search --"
	
	while :
	do
		echo -n "Search query (q to exit, m to show menu ) : "
		read INPUT

                if [ "$INPUT" = "q" ]; then
                	exit
                elif [ "$INPUT" = "m" ]; then
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
