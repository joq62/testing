%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(dynamic).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------
-include("src/test.hrl").

%% External exports
-export([start/0,
	 master/1,
	 slave/0,
	 add_extra_nodes/1
	]).


-define(AllVms,['b0@asus','b1@asus','b2@asus']).
-define(AllVmId,["b0","b1","b2"]).
-define(WAIT_FOR_TABLES,5000).

%% ====================================================================
%% External functions
%% ====================================================================
start()->
    [rpc:call(Vm,init,stop,[])||Vm<-?AllVms],
    timer:sleep(4000),
  
    io:format(" ~p~n",[{?MODULE,?LINE,
			rpc:call('mnesia_test@asus',dynamic,master,[nodes()])}]),  
    timer:sleep(500), 
   

    io:format(" ~p~n",[{?MODULE,?LINE,
			start_vm(?AllVmId,[])}]),
    io:format(" ~p~n",[{?MODULE,?LINE,
			[net_adm:ping(Vm)||Vm<-?AllVms]}]),
 
    io:format(" ~p~n",[{?MODULE,?LINE,
			rpc:call('b0@asus',dynamic,master,[[node()|?AllVms]])}]),
    timer:sleep(500),
    io:format(" ~p~n",[{?MODULE,?LINE,
			rpc:call('b1@asus',dynamic,master,[[node()|?AllVms]])}]),
    timer:sleep(500),
    io:format(" ~p~n",[{?MODULE,?LINE,
			rpc:call('b2@asus',dynamic,master,[[node()|?AllVms]])}]),
    io:format(" ~p~n",[{?MODULE,?LINE,
			mnesia:info()}]),
    timer:sleep(500),   
    
    load_info(),
    kill_and_start(),
   
    
    ok. 
 %   io:format(" ~p~n",[{R,?MODULE,?LINE}]).


%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
 kill_and_start()->
    ?assertEqual([host2,host1],
		 rpc:call('b0@asus',mnesia,dirty_all_keys,[computer])),   
    
    rpc:call('b0@asus',init,stop,[]),
    timer:sleep(2000),
    ?assertEqual({badrpc,nodedown},
		 rpc:call('b0@asus',mnesia,dirty_all_keys,[computer])),  

    ?assertEqual([ok],
		 start_vm(["b0"],[])),  
    
    pong=net_adm:ping('b0@asus'),
    ok=rpc:call('b0@asus',mnesia,start,[]),
    timer:sleep(2000),
    
    rpc:call('b0@asus',dynamic,add_extra_nodes,[node()]),
    timer:sleep(2000),
  %  ?assertEqual([host2,host1],
%		 rpc:call('b0@asus',mnesia,dirty_all_keys,[computer])),   
    
    io:format(" ~p~n",[{?MODULE,?LINE,
			mnesia:info()}]),
    timer:sleep(2000),
    ok.
    

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
load_info()->
    db_computer:create(host1,sshid1,sshpwd1,ipaddr1,port1,status1),
    db_computer:create(host2,sshid2,sshpwd2,ipaddr2,port2,status2),
    ?assertEqual([{host2,sshid2,sshpwd2,ipaddr2,port2,status2},
		  {host1,sshid1,sshpwd1,ipaddr1,port1,status1}],
		 db_computer:read_all()),
    ok.
   


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

master(AllVms)->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:start(),
    dynamic_db_init(lists:delete(node(), AllVms)).

slave()->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:start().

dynamic_db_init([])->
    mnesia:create_table(vm,[{attributes, record_info(fields, vm)}]),
    mnesia:create_table(computer,[{attributes, record_info(fields, computer)}]);

dynamic_db_init(AllNodes)->
    io:format(" ~p~n",[{?MODULE,?LINE,AllNodes}]),
    add_extra_nodes(AllNodes).

%add_extra_nodes([])->
%    ok;
add_extra_nodes([Node|T])->
    case mnesia:change_config(extra_db_nodes, [Node]) of
	{ok,[Node]}->
	    io:format(" ~p~n",[{?MODULE,?LINE,node()}]),
	    mnesia:add_table_copy(schema, node(),ram_copies),
	    mnesia:add_table_copy(vm, node(), ram_copies),
	    mnesia:add_table_copy(computer, node(), ram_copies),
	    Tables=mnesia:system_info(tables),
	    mnesia:wait_for_tables(Tables,?WAIT_FOR_TABLES);
	_ ->
	    io:format(" ~p~n",[{?MODULE,?LINE,node()}]),
	    add_extra_nodes(T)
   % end,
   % add_extra_nodes(T).
    end.

start_vm([],R)->
    R;
start_vm([VmId|T],Acc)->
    os:cmd("erl -pa test_ebin -sname "++VmId++" -setcookie abc -detached "),
    Vm=list_to_atom(VmId++"@"++"asus"),
    R=check_started(500,Vm,10,{error,[Vm]}),
    start_vm(T,[R|Acc]).


check_started(_N,_Vm,_Timer,ok)->
    ok;
check_started(0,_Vm,_Timer,Result)->
    Result;
check_started(N,Vm,Timer,_Result)->
    NewResult=case net_adm:ping(Vm) of
		  pong->
		      ok;
		  Err->
		      timer:sleep(Timer),
		      {error,[Err,Vm]}
	      end,
    check_started(N-1,Vm,Timer,NewResult).
