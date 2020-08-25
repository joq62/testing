%% @author Paolo Oliveira <paolo@fisica.ufc.br>
%% @copyright 2015-2016 Paolo Oliveira (license MIT)
%% @version 1.0.0
%% @doc
%% A simple, pure erlang implementation of a module for <b>Raspberry Pi's General Purpose
%% Input/Output</b> (GPIO), using the standard Linux kernel interface for user-space, sysfs,
%% available at <b>/sys/class/gpio/</b>.
%% @end
 
-module(gpio_in_out).
-export([start/0]).
-author('joq erlang').

%% API

%% Rat 0

-define(InitInRat0,os:cmd("echo 18 > /sys/class/gpio/export"), 
	           timer:sleep(500),
	           os:cmd("echo in > /sys/class/gpio/gpio18/direction")).
-define(ReadRat0,lists:nth(1,string:tokens(os:cmd("cat /sys/class/gpio/gpio18/value"),[$\n]))).

-define(InitOutRat0,os:cmd("echo 21 > /sys/class/gpio/export"), 
	           timer:sleep(500),
	           os:cmd("echo out > /sys/class/gpio/gpio21/direction")).
-define(HIGHRat0,os:cmd("echo 1 > /sys/class/gpio/gpio21/value")).
-define(LOWRat0,os:cmd("echo 0 > /sys/class/gpio/gpio21/value")).

%% Rat 1

-define(InitInRat1,os:cmd("echo 23 > /sys/class/gpio/export"),
	           timer:sleep(500),
	           os:cmd("echo in > /sys/class/gpio/gpio23/direction")).
-define(ReadRat1,lists:nth(1,string:tokens(os:cmd("cat /sys/class/gpio/gpio23/value"),[$\n]))).

-define(InitOutRat1,os:cmd("echo 20 > /sys/class/gpio/export"),
                    timer:sleep(500), 
	           os:cmd("echo out > /sys/class/gpio/gpio20/direction")).
-define(HIGHRat1,os:cmd("echo 1 > /sys/class/gpio/gpio20/value")).
-define(LOWRat1,os:cmd("echo 0 > /sys/class/gpio/gpio20/value")).

	  
% @doc: Initialize a Pin as input or output.
start()->
    
    init(),
 %   timer:sleep(1000),
%    init(),
    Rat0= case ?ReadRat0 of 
	      "1"->
		  ?HIGHRat0,
		  send_mail("joakim.leche@gmail","joakim.leche@gmail",
		      "A mouse is caught!","Please go and fix the mouse trap"),
		  true;
	      "0"->
		  ?LOWRat0,
		  false
	  end,
    Rat1= case ?ReadRat1 of 
	      "1"->
		  ?HIGHRat1,
		  send_mail("joakim.leche@gmail","joakim.leche@gmail",
		      "A mouse is caught!","Please go and fix the mouse trap"),
		  true;
	      "0"->
		  ?LOWRat1,
		  false
	  end,
	
    loop(Rat0,Rat1).

loop(Rat0,Rat1)->
    timer:sleep(500),
    case {Rat0,?ReadRat0} of
	{false,"1"}->
	    ?HIGHRat0,
	    send_mail("joakim.leche@gmail","joakim.leche@gmail",
		      "A mouse is caught!","Please go and fix the mouse trap"),
	    NewRat0=true;
	{true,"1"}->
	    NewRat0=Rat0;
	{true,"0"}->
	    ?LOWRat1,
	    NewRat0=false;
	{false,"0"} ->
	    NewRat0=Rat0
    end,
    case {Rat1,?ReadRat1} of
	{false,"1"}->
	    ?HIGHRat1,
	    send_mail("joakim.leche@gmail","joakim.leche@gmail",
		      "A mouse is caught!","Please go and fix the mouse trap"),
	    NewRat1=true;
	{true,"1"}->
	    NewRat1=Rat1;
	{true,"0"}->
	    ?LOWRat1,
	    NewRat1=false;
	{false,"0"} ->
	    NewRat1=Rat1
    end,
    io:format("Rat0 = ~p~n",[{?MODULE,?LINE,?ReadRat0}]),
    io:format("Rat1 = ~p~n",[{?MODULE,?LINE,?ReadRat1}]),
    loop(NewRat0,NewRat1).

    
init()->
    timer:sleep(100),
 %   []=
    ?InitInRat0,
    timer:sleep(500),
   % []=  
    ?InitOutRat0,
    timer:sleep(500),
   % []=
    ?LOWRat0,
    timer:sleep(100), 

   % []=
    ?InitInRat1,
    timer:sleep(100),
    %[]=
    ?InitOutRat1,
    timer:sleep(100),
   % []=
    ?LOWRat1.
    

send_mail(_To,_From,_Subject,_Msg)->
    os:cmd("ssmtp joakim.leche@gmail.com < rat_info.txt"),
    ok.
    
	
