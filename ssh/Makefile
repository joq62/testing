## set the paths for a default setup
all:
	erlc -o ebin src/*.erl;
	erl -pa ebin -s my_ssh start -sname my_ssh -setcookie abc;
test:
	rm -rf ebin/* *~;
	erlc -o ebin src/*.erl;
	erl -pa ebin -s my_ssh test -sname my_ssh -setcookie abc;
