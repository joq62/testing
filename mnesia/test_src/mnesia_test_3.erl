%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(mnesia_test_3).  
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include("infra_3.hrl").
%%---------------------------------------------------------------------
-export([start/0]).

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:emulate loader
%% Description: requires pod+container module
%% Returns: non
%% --------------------------------------------------------------------
start()->
    ?debugMsg("test_1"),
    test_1(),
    ?debugMsg("sd"),
    sd(),
 %   ?debugMsg("Deployment_test"),
 %   deployment_test(),
  %  ?debugMsg("test_3"),
  %  test_3(),
    ok.






%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
sd()->
    ?assertMatch([],etcd:read_sd("s1")),
    etcd:create(#service_discovery{id="s1",vms=[]}),
    ?assertMatch([{service_discovery,"s1",[]}],etcd:read_sd("s1")),
    etcd:update_sd("s1",'vm1@host1'),
    ?assertMatch([{service_discovery,"s1",['vm1@host1']}],etcd:read_sd("s1")),
    etcd:update_sd("s1",'vm1@host2'),
    ?assertMatch([{service_discovery,"s1",['vm1@host2','vm1@host1']}],etcd:read_sd("s1")),
    etcd:delete_sd_vm("s1",'vm1@host2'),
    ?assertMatch([{service_discovery,"s1",['vm1@host1']}],etcd:read_sd("s1")), 

    etcd:create(#service_discovery{id="s2",vms=['vm1@host2']}),
    ?assertMatch([{service_discovery,"s2",['vm1@host2']}],etcd:read_sd("s2")),

    etcd:update_sd("glurk",'vm1@host2'),
    ?assertMatch([{service_discovery,"s2",['vm1@host2']},
		  {service_discovery,"s1",['vm1@host1']}],etcd:read_all(service_discovery)),
    

    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------


deployment_test()->
    Path="configs",

    % Deploy math.deployment
    
    % 1. Identfy instances to deploy

    
    % 2. Identfy service to deploy
 

    % 3. Get path to Service repo

   
    % 4. Get a vm from computer to load on 

    

    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

test_1()->
    % Computer
    {ok,[C1]}=file:consult("configs/asus.computer"),
    ?assertMatch([],etcd:read_computer("asus")),
    etcd:create(C1), 
    ?assertMatch([{computer,"asus","pi","festum01",
		  "192.168.0.100",60100}],etcd:read_computer("asus")),
    
    %service_def
    {ok,[S1]}=file:consult("configs/adder.service_def"),
    ?assertMatch([],etcd:read_service_def("adder_service")),
    etcd:create(S1), 
    ?assertMatch({"adder_service","1.2.3",
		  "https://github.com/joq62/"},etcd:read_service_def("adder_service")),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
