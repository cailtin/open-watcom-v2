#!/bin/sh

function usage() {
    echo usage: $0 prgname errorfile
    exit
}

function print_header() {
    echo \# -----------------------------
    echo \#   Test $TEST
    echo \# -----------------------------
}

function do_check() {
    if [ "$?" == "0" ]; then
        echo \# Test $TEST successful
    else
        echo \#\# MACRO \#\# >> $LOGFILE
        echo Error: Test $TEST unsuccessful!!! | tee -a $LOGFILE
	exit
    fi
}

if [ "$2" == "" ]; then 
    usage
fi

LOGFILE=$2
echo \# ===========================
echo \# Start Macro Tests
echo \# ===========================

TEST=1
print_header
$1 -ms -h -f macro01 > tmp.out 2>&1
diff -b macro01.chk tmp.out
do_check

TEST=2A
print_header
$1 -h -f macro02 > tmp.out 2>&1
diff -b macro02a.chk tmp.out
do_check

TEST=2B
print_header
$1 -h -ms -f macro02 > tmp.out 2>&1
diff -b macro02b.chk tmp.out
do_check

TEST=3A
print_header
$1 -h -f macro03 > tmp.out 2>&1
diff -b macro03a.chk tmp.out
do_check

TEST=3B
print_header
export fubar=test depends on this environment variable
$1 -h -ms -f macro03 > tmp.out 2>&1
unset fubar
diff -b -i macro03b.chk tmp.out
do_check

TEST=4A
print_header
$1 -h -f macro04 > tmp.out 2>&1
diff -b macro04a.chk tmp.out
do_check

TEST=4B
print_header
$1 -h -ms -f macro04 > tmp.out 2>&1
diff -b macro04b.chk tmp.out
do_check

TEST=5
print_header
echo >hello.boo
echo >hello.tmp
echo >hello.c
$1 -h -ms -f macro05u > tmp.out 2>&1
diff -b macro05u.chk tmp.out
do_check
rm hello.boo hello.tmp hello.c

TEST=6
print_header
echo >hello.obj
echo >hello2.obj
echo >hello.c
echo >hello2.c
$1 -h -ms -f macro06 -a > tmp.out 2>&1
diff -b macro06.chk tmp.out
do_check

TEST=7
print_header
echo >hello.obj
echo >hello2.obj
echo >hello.c
echo >hello2.c
$1 -h -ms -m -f macro07 -a cc=wcl386 > tmp.out 2>&1
diff -b macro07.chk tmp.out
do_check

TEST=8
print_header
$1 -h -f macro08 > tmp.out 2>&1
diff -b macro08.chk tmp.out
do_check

rm -f hello.obj hello2.obj hello.boo hello.tmp hello.c hello2.c 

rm tmp.out
