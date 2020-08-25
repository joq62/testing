%% @author Paolo Oliveira <paolo@fisica.ufc.br>
%% @copyright 2015-2016 Paolo Oliveira (license MIT)
%% @version 1.0.0
%% @doc
%% A simple, pure erlang implementation of a module for <b>Raspberry Pi's General Purpose
%% Input/Output</b> (GPIO), using the standard Linux kernel interface for user-space, sysfs,
%% available at <b>/sys/class/gpio/</b>.
%% @end
 
-module(my_ssh).
-export([start/0,send/1,send/5,test/0]).
-author('joq erlang').

start()->
    ssh:start().
    
    
test()->
    ssh:start(),
    rpc:call('w@sthlm_1',init,stop,[]),
    timer:sleep(1000),
    send("rm -rf include configs *_service  erl_crasch.dump"),
    send("git clone https://github.com/joq62/include.git"),
    send("git clone https://github.com/joqerlang/adder_service.git"),
    send("cp adder_service/src/*.app adder_service/ebin"),
    io:format("~p~n",[send("erlc -I include -o adder_service/ebin adder_service/src/*.erl")]),
    io:format("~p~n",[send("erl -pa */ebin -s adder_service start -sname w -detached -setcookie abc")]),
    timer:sleep(2000),
    pong=net_adm:ping(w@sthlm_1),
    io:format("~p~n",[rpc:call('w@sthlm_1',adder_service,add,[20,22],3000)]),
     rpc:call('w@sthlm_1',init,stop,[],2000),
    ok.


send(Msg)->
    {ok,ConRef}=ssh:connect("192.168.0.110",60110,[{user,"pi"},{password,"festum01"}]),
%    {ok,ConRef}=ssh:connect(Ip,Port,[{user,User},{password,Password}]),
    {ok,ChanId}=ssh_connection:session_channel(ConRef,infinity),
    ssh_connection:exec(ConRef,ChanId,Msg,infinity),
    R=rec(na),
    R.

send(Ip,Port,User,Password, Msg)->
%    {ok,ConRef1}=ssh:connect("varmdo.asuscomm.com",50222,[{user,"pi"},{password,"festum01"}]).
    {ok,ConRef}=ssh:connect(Ip,Port,[{user,User},{password,Password}]),
    {ok,ChanId}=ssh_connection:session_channel(ConRef,infinity),
    ssh_connection:exec(ConRef,ChanId,Msg,infinity),
    R=rec(na),
    R.



rec(Msg)->
    receive 
	{ssh_cm,_,{data,0,0,BinaryMsg}}->
	    rec(BinaryMsg);
        {ssh_cm,_,{eof,0}}->
	     rec(Msg);
	{ssh_cm,_,{exit_status,0,0}}->
	     rec(Msg);
	{ssh_cm,_,{closed,0}}->
	    Msg
    end.
