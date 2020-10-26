all:
	rm -rf adder_service/ebin/*;
	rm -rf divi_service/ebin/*;
	cp ../adder_service/src/*.app adder_service/ebin;
	cp ../divi_service/src/*.app divi_service/ebin;	
	erlc -o adder_service/ebin ../adder_service/src/*.erl;
	erlc -o divi_service/ebin ../divi_service/src/*.erl;
#	erlc -o test_ebin test_src/*.erl;
#	erl -pa ebin -pa test_ebin -s adder_service_tests start -sname test_adder_service
	echo ok
