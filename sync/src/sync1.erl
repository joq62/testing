%% @author Paolo Oliveira <paolo@fisica.ufc.br>
%% @copyright 2015-2016 Paolo Oliveira (license MIT)
%% @version 1.0.0
%% @doc
%% A simple, pure erlang implementation of a module for <b>Raspberry Pi's General Purpose
%% Input/Output</b> (GPIO), using the standard Linux kernel interface for user-space, sysfs,
%% available at <b>/sys/class/gpio/</b>.
%% @end
 
-module(sync1).
-export([loop/0]).
-author('joq erlang').

call(Msg)->
    S=self(),
    
    

loop()->
    receive
	{Pid,pid}->
	    Pid!self();
	{Pid,Msg}->
	    io:format("~p~n",[{Pid,Msg}]),
	    loop();
	exit ->
	    io:format("exit ~n")
    end.

