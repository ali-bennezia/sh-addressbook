#! /bin/sh

. ./records.lib.sh

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

BREAK=0
function interrupt()
{
	BREAK=1
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
	while [ "$BREAK" -ne "1" ]
	do
		echo -n "Choose an option (CTRL+C to quit) : "
		read SELECTION
	
		[ "$BREAK" -eq 1 ] && break

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
trap interrupt 2
check_data_file
while :
do
	# SROOT="./"
	display_menu
	request_option

	if [ "$BREAK" -eq 1 ]; then
		BREAK=0
		clear
		exit
	fi

	# SROOT="./../"
	flush_selection
	# read
done

