test:
	rm -rf ebin/* src/*~ test_ebin/* test_src/*~;
	cp src/*.app ebin;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s adder_service_tests start -sname test_adder_service
