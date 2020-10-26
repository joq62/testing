## set the paths for a default setup
all:
	rm -rf ebin/* test_ebin/* *src/*.beam  *~ */*~ Mnesia*;
	erlc -o test_ebin test_src/*.erl;
	erlc -o ebin src/*.erl;
	erl -pa ebin -pa test_ebin -s mnesia_tests start -sname mnesia_test -setcookie abc
