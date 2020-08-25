%% @author Paolo Oliveira <paolo@fisica.ufc.br>
%% @copyright 2015-2016 Paolo Oliveira (license MIT)
%% @version 1.0.0
%% @doc
%% A simple, pure erlang implementation of a module for <b>Raspberry Pi's General Purpose
%% Input/Output</b> (GPIO), using the standard Linux kernel interface for user-space, sysfs,
%% available at <b>/sys/class/gpio/</b>.
%% @end
 
-module(sync).
-export([start/0]).
-author('joq erlang').



loop()->
    receive
	do_sync->
	    Parent=self(),
	    Pid=spawn(fun()->do_sync(Parent) end),
	    receive 
		{Pid,false}->
		    active;
		{Pid,true}->
		    passive;
		{ReqPid,wantToStepUp} ->
		    Pid!abort,
		    timer:sleep(random()),
		    Parent!do_sync
	    after T->
		    active
	    end;
	{ReqPid,wantToStepUp}->
	    MyStatus=my_status(),
	    ReqPid!{self(),MyStatus}
    end,
    loop().

do_sync(ParentPid)->
    Pid=spawn(fun()->map_reduce(MasterPids) end),
    receive
	{ParentPid,abort}->
	    ok;
	{Pid,Result}->
	    ParentPid!Result
    after 5000->
	    ParentPid!false
    end.   
		 

map_reduce([])->     
    [];
map_reduce(MasterPids) -> 
    do_the_work(MasterPids).

do_the_work(X)->
	    
    [MasterPid!{self(),wantToStepUp}||MasterPid<-MasterPids],
    [X].
	
    
