#! /bin/sh

. ./records.lib.sh

# SROOT="./"
# add_record Jean Francis jeanfr@gmail.com "8 rue de la marre"
# search_records "Jean"
# does_record_exist "Jean:Francis:jeanfr@gmail.com:8 rue de la marre"
# RES=$?
# echo $RES
# exit

SELECTION="menu"

function display_menu()
{
	clear
	echo "== Address book menu =="
	i=1
	for option in `ls ./menu`
	do
		if [ ! -f "./menu/$option"  -a -r "./menu/$option" ]; then
			continue
		fi
		echo "$i)" `head -n 1 ./menu/$option | cut -c 3-`
		i=`expr $i + 1`
	done
}

function get_menu_options_count()
{
	echo `ls ./menu | wc -l`
}

function get_selection_path()
{
	SELECTIONPATH=`ls ./menu | head -n $SELECTION | tail -n 1`
	echo "./menu/$SELECTIONPATH"
}

function request_option()
{
	while :
	do
		echo -n "Choose an option (q to quit) : "
		read SELECTION
		if [ "$SELECTION" = "q" ]; then
			clear
			exit
		fi
		SELECTION=`echo "$SELECTION" | tr -d [a-zA-Z][:space:]`
		[ -z "$SELECTION" ] && SELECTION=0
		if [ "$SELECTION" -lt 1 -o "$SELECTION" -gt `get_menu_options_count` ]; then
			echo "Incorrect option. Please try again."
		else
			break
		fi
	done
}

function flush_selection()
{
	. `get_selection_path`
	execute_option
}

function check_data_file()
{
	touch data
	if [ ! -f data -a -r data -a -w data ]; then
		echo "Error: Couldn't create data file."
		exit
	fi
}

SROOT="./"
check_data_file
while :
do
	# SROOT="./"
	display_menu
	request_option
	# SROOT="./../"
	flush_selection
	# read
done

