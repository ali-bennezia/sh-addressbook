#! /bin/sh

. ./records.lib.sh

SELECTION="menu"

function request_confirmation()
{
	while [ $BREAK -ne 1 ]
	do
		echo "Confirm ? (y/n)"
		read CONFIRM
		if [ "$CONFIRM" = "y" ]; then
			return 1
		elif [ "$CONFIRM" = "n" ]; then
			return 0
		fi
	done
}

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
	ENTRIES=`wc -l ${SROOT}data | cut -d" " -f1`
	SELPATH=`get_selection_path`
	ENABLEIFNOENTRIES=`head -n 2 "$SELPATH" | tail -n 1 | cut -c3-`
	if [ $ENTRIES -eq 0 -a $ENABLEIFNOENTRIES -eq 0 ]; then
		echo "Option unavailable. There are currently no records on the address book."
		read
		return 1
	fi
	. `get_selection_path`
	execute_option
	return 0
}

function check_data_file()
{
	touch data
	if [ ! -f data -a -r data -a -w data ]; then
		echo "Error: Couldn't create data file."
		exit
	fi
	return 0
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

