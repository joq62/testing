## set the paths for a default setup
all:
	erlc -o ebin src/*.erl;
	erl -pa ebin -s gpio_in_out start -sname gpio_in_out
