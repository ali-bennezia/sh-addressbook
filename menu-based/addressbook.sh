#! /bin/sh

. ./records.lib.sh

SELECTION="menu"
MENUSELECTION=1

function menu_down()
{
	MAXCOUNT=`get_menu_options_count`
	MENUSELECTION=`expr $MENUSELECTION + 1`
	[ $MENUSELECTION -gt $MAXCOUNT ] && MENUSELECTION=`expr $MAXCOUNT`
}

function menu_up()
{
	MENUSELECTION=`expr $MENUSELECTION - 1`
	[ $MENUSELECTION -lt 1 ] && MENUSELECTION=1
}

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
		if [ $MENUSELECTION -eq $i ]; then
			echo -n "> "
		else
			echo -n "* "
		fi
		echo `head -n 1 ./menu/$option | cut -c 3-`
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
	display_menu
	read -s -n1 MENUINPUT

	if [ "$BREAK" -eq 1 ]; then
		BREAK=0
		clear
		exit
	fi

	if [ "$MENUINPUT" = $'\x1B' ]; then
		read -s -n1 MENUINPUT
		if [ "$MENUINPUT" = "[" ]; then
			read -s -n1 MENUINPUT
			case "$MENUINPUT" in
				A) menu_up  ;;
				B) menu_down ;;
			esac
		fi
	elif [ "$MENUINPUT" = $'\0A' ]; then
		SELECTION=$MENUSELECTION
		clear
		flush_selection
	fi
done

