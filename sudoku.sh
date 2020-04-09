#!/usr/bin/env bash


# CONVENTION
#   Variables, constants, and functions  are delimited by underscore
#   Variables are in lower case
#   Constants are in upper case
#   Any function, firstly, must set its local parameters by an appropriate parameter with "local"
#   Return value of any function is put into a global 'ret_val' variable
#   Return value of function is mostly ignored (maybe in some cases it would be used as a check
#	whether function terminated correctly)
# END: CONVENTION

# COMMON SCRIPT PREPARATIONS
ret_val=
_MSG_FMT="$%.23s %s[%s]: %s\n"
BOARD_SIZE=9
# END: COMMON SCRIPT PREPARATIONS
msg() {
    local message=$1
    local drop=$2
    printf "${_MSG_FMT}" $(date +%F.%T.%N) ${BASH_SOURCE[1]##*/} ${BASH_LINENO[0]} "${message}"
    [ -n "$drop" ] && { echo "ABORTING"; exit "${drop}"; }
}


# msg "This is a test of msg!"
# msg "Tthis is a test of msg2!" -1

function test_me() {
    local param1=$1
    local param2=$2
    if [ -n "$param2" ]
    then
	echo "returning first parameter"
	ret_val="$param2"
	return
    fi
    ret_val="second param is not set"
    
}

# test_me "Hello world"
# echo "$ret_val"
# test_me "Second attempt" "Blabla"
# echo "$ret_val"

function as_index() {
    local i=$1
    local j=$2
    if [ "$i" -le "-1" -o "$i" -gt "8" ] || [ "$j" -le "-1" -o "$i" -gt "8" ]
    then
	msg "Invalid index i=$i, j=$j" -1
    fi
    ret_val=$((i * 9 + j))
}

as_index 0 3
echo "as_index 0 3" $ret_val
as_index 3 3
echo "as_index 3 3" $ret_val

# as_index "10" "4"

hello="hello world"
i1=1
echo ${hello:$i1:1}

function print_board() {
    local board=$1
    local HORIZ_DELIM="-------------"
    # msg "starting print board"
    local i=
    local j=
    # echo $HORIZ_DELIM
    for ((i = 0; $i < $BOARD_SIZE; i++))
    do
	if (( i % 3 == 0 ))
	then
	    echo "$HORIZ_DELIM"
	fi
	for ((j = 0; $j < $BOARD_SIZE; j+=3))
	do
	    as_index $i $j
	    local idx=$ret_val
	    echo -n "|${board:${idx}:3}"
	done
	echo "|"
    done
    echo $HORIZ_DELIM
}
test_board="123456789\
987654321\
123456789\
987654321\
123456789\
987654321\
123456789\
987654321\
123456789"
print_board $test_board


