%% @author Paolo Oliveira <paolo@fisica.ufc.br>
%% @copyright 2015-2016 Paolo Oliveira (license MIT)
%% @version 1.0.0
%% @doc
%% A simple, pure erlang implementation of a module for <b>Raspberry Pi's General Purpose
%% Input/Output</b> (GPIO), using the standard Linux kernel interface for user-space, sysfs,
%% available at <b>/sys/class/gpio/</b>.
%% @end
 
-module(my_node).
-export([ls/0,start/0,send/1,send/5,test/0]).
-author('joq erlang').

-define(IP,"192.168.1.50").
-define(PORT,60122).
-define(VM0,'30000@asus').
-define(VM1,'30001@asus').

start()->
    ssh:start().
    
    
ls()->
    ssh:start(),
    X1=binary_to_list(send("ls")),
    X=string:tokens(X1,"\n"),
    io:format("~p~n",[X]),
    
    ok.
    
test()->
    ssh:start(),
    io:format("~p~n",[net_adm:ping(?VM0)]),
    io:format("~p~n",[net_adm:ping(?VM1)]),
    rpc:call(?VM0,init,stop,[]),
    timer:sleep(200),
    rpc:call(?VM1,init,stop,[]),
    timer:sleep(200),
    os:cmd("rm -rf 30000 30001"),
    os:cmd("mkdir 30000"),
    os:cmd("mkdir 30001"),
    os:cmd("rm -rf include configs *_service  erl_crasch.dump"),
    os:cmd("git clone https://github.com/joq62/include.git"),
    io:format("~p~n",[{?MODULE,?LINE,os:cmd("git clone https://github.com/joq62/adder_service.git 30000")}]),
  %  io:format("~p~n",[{?MODULE,?LINE,send("pwd")}]),
    timer:sleep(200),
    io:format("~p~n",[{?MODULE,?LINE,os:cmd("git clone https://github.com/joq62/adder_service.git 30001")}]),

    timer:sleep(200),
%    io:format("~p~n",[send("pwd ")]),

    io:format("~p~n",[{?MODULE,?LINE,os:cmd("cp 30000/src/*.app 30000/ebin")}]),
    timer:sleep(200),
    io:format("~p~n",[{?MODULE,?LINE,os:cmd("cp 30001/src/adder_service.app 30001/ebin")}]),
    timer:sleep(200),
    io:format("~p~n",[{?MODULE,?LINE,os:cmd("erlc -I include -o 30000/ebin 30000/src/*.erl")}]),
    io:format("~p~n",[{?MODULE,?LINE,c:cd("30000")}]),   
    io:format("~p~n",[{?MODULE,?LINE,os:cmd("erl -pa ebin -s adder_service boot -sname 30000  -setcookie abc -detached")}]),
    timer:sleep(1000),
    io:format("~p~n",[{?MODULE,?LINE,c:cd("..")}]),   
 %   io:format("~p~n",[{?MODULE,?LINE,os:cmd("erl -pa 30000/ebin -s adder_service boot -sname 30000  -setcookie abc -detached")}]),

    io:format("~p~n",[{?MODULE,?LINE,os:cmd("erlc -I include -o 30001/ebin 30001/src/*.erl")}]),

    io:format("~p~n",[{?MODULE,?LINE,c:cd("30001")}]),     
    io:format("~p~n",[{?MODULE,?LINE,os:cmd("pwd")}]),  
    io:format("~p~n",[{?MODULE,?LINE,os:cmd("erl -pa ebin -s adder_service boot -sname 30001  -setcookie abc -detached")}]),
    timer:sleep(1000),
    io:format("~p~n",[{?MODULE,?LINE,c:cd("..")}]),   
%    io:format("~p~n",[{?MODULE,?LINE,os:cmd("erl -pa 30001/ebin -s adder_service boot -sname 30001  -setcookie abc -detached")}]),
    timer:sleep(2000),
    pong=net_adm:ping(?VM0),
    pong=net_adm:ping(?VM1),
    io:format("~p~n",[rpc:call(?VM0,adder_service,add,[20,22],3000)]),
    io:format("~p~n",[rpc:call(?VM1,adder_service,add,[20,220],3000)]),
 %   rpc:call(?VM0,init,stop,[],2000),
 %   rpc:call(?VM1,init,stop,[],2000),
    ok.


send(Msg)->
    {ok,ConRef}=ssh:connect(?IP,?PORT,[{user,"pi"},{password,"festum01"}]),
%    {ok,ConRef}=ssh:connect(Ip,Port,[{user,User},{password,Password}]),
    {ok,ChanId}=ssh_connection:session_channel(ConRef,infinity),
    ssh_connection:exec(ConRef,ChanId,Msg,infinity),
    R=rec(<<"na">>),
    X1=binary_to_list(R),
    X=string:tokens(X1,"\n"),
    io:format("~p~n",[{?MODULE,?LINE,X}]),
    X.

send(Ip,Port,User,Password, Msg)->
%    {ok,ConRef1}=ssh:connect("varmdo.asuscomm.com",50222,[{user,"pi"},{password,"festum01"}]).
    {ok,ConRef}=ssh:connect(Ip,Port,[{user,User},{password,Password}]),
    {ok,ChanId}=ssh_connection:session_channel(ConRef,infinity),
    ssh_connection:exec(ConRef,ChanId,Msg,infinity),
    R=rec(<<"na">>),
    X1=binary_to_list(R),
    X=string:tokens(X1,"\n"),
    io:format("~p~n",[{?MODULE,?LINE,X}]),
    X.



rec(Msg)->
    receive 
	{ssh_cm,_,{data,0,0,BinaryMsg}}->
	    io:format("ssh_cm,_,{data,0,0 ~p~n",[{?MODULE,?LINE}]),
	    rec(BinaryMsg);
        {ssh_cm,_,{eof,0}}->
	    io:format("ssh_cm,_,{eof,0} ~p~n",[{?MODULE,?LINE}]),
	    rec(Msg);
	{ssh_cm,_,{exit_status,0,0}}->
	    io:format("ssh_cm,_,{exit_status,0,0} ~p~n",[{?MODULE,?LINE}]),
	     rec(Msg);
	{ssh_cm,_,{closed,0}}->
	    io:format("ssh_cm,_,{closed,0} ~p~n",[{?MODULE,?LINE}]),
	    Msg;
	{ssh_cm,_,{data,_,_,X}}->
	    io:format("ssh_cm,_,{data,_,_,X} ~p~n",[{?MODULE,?LINE}]),
	    X;
	{ssh_cm,_,Term}->
	    io:format("ssh_cm,_,Term ~p~n",[{?MODULE,?LINE}]),
	    term_to_binary(Term);
	Err ->
	    io:format("ssh_cm,_,Err ~p~n",[{?MODULE,?LINE,Err}]),
	    Err
    end.
