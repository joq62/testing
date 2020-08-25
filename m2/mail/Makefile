## set the paths for a default setup

all:
	erlc -o ./ebin src/*.erl
clean:
	rm -rf */*~ *.beam ebin/*.beam *~
test:
	erlc -o ./ebin src/*.erl;
	erl -pa ./ebin -s mail_test test
