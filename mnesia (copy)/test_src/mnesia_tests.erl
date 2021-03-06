%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(mnesia_tests).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]).



%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
    ?debugMsg("Test system setup"),
    ?assertEqual(ok,setup()),

    %% Start application tests

    ?debugMsg("mnesia test "),
    ?assertEqual(ok,mnesia_test_3:start()),    
    
    ?debugMsg("ssh test "),
  %  ?assertEqual(ok,ssh_test:start()),
    
    ?debugMsg("node test "),
  %  ?assertEqual(ok,node_test:start(2)),


    ?debugMsg("Start stop_test_system:start"),
    %% End application tests
    cleanup(),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    mnesia:create_schema([node()]), %Should be started by db_mnesia
    mnesia:start(),
    db_computer:create_table(),
    db_service_def:create_table(),
    db_service_discovery:create_table(),
    db_deployment_spec:create_table(),
    db_deployment:create_table(),
    
    ok.

cleanup()->
    mnesia:stop(),
    init:stop().




