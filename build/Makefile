all:
	rm -rf adder_*;
	mkdir adder_100;
	git clone https://github.com/joqerlang/adder_service.git;	
	mv adder_service/* adder_100;
	rm -rf adder_service;
	cp adder_100/src/*.app adder_100/ebin;
	erlc -o adder_100/ebin adder_100/src/*.erl;
	erl -pa adder_100/ebin -s adder_service start -sname adder_100
