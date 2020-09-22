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
    ?debugMsg("db_computer"),
    db_computer(),
    ?debugMsg("db_service_def"),
    db_service_def(),
    ?debugMsg("db_service_discovery"),
    db_service_discovery_test(),
    ?debugMsg("db_deployment_spec"),
    db_deployment_spec(),
    ?debugMsg("db_deployment"),
    db_deployment(),
    ok.






%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
db_deployment()->
    db_deployment:create(#deployment{id="etcd",vsn="1.0.0",
				     service_id="etcd_service",
				     service_vsn="2.3.4",
				     vm='2378@host1'}),
    ?assertMatch([{"etcd","1.0.0","etcd_service","2.3.4",'2378@host1'}],
		 db_deployment:read_all()),
    db_deployment:create(#deployment{id="etcd",vsn="1.0.0",
				     service_id="etcd_service",
				     service_vsn="2.3.4",
				     vm='2379@host1'}),
    db_deployment:create(#deployment{id="etcd",vsn="1.0.0",
				     service_id="etcd_service",
				     service_vsn="2.3.4",
				     vm='2380@host1'}),
    
    ?assertMatch([{"etcd","1.0.0","etcd_service","2.3.4",'2378@host1'},
		  {"etcd","1.0.0","etcd_service","2.3.4",'2379@host1'},
		  {"etcd","1.0.0","etcd_service","2.3.4",'2380@host1'}],
		 db_deployment:read("etcd")),


    ?assertMatch([{"etcd","1.0.0","etcd_service","2.3.4",'2378@host1'},
		  {"etcd","1.0.0","etcd_service","2.3.4",'2379@host1'},
		  {"etcd","1.0.0","etcd_service","2.3.4",'2380@host1'}],
		 db_deployment:read_all()),

    {atomic,ok}=db_deployment:delete("etcd","1.0.0","etcd_service","2.3.4",'2379@host1'),

    ?assertMatch([{"etcd","1.0.0","etcd_service","2.3.4",'2378@host1'},
		  {"etcd","1.0.0","etcd_service","2.3.4",'2380@host1'}],
		 db_deployment:read_all()),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------


db_deployment_spec()->

    {ok,[D1]}=file:consult("configs/math.deployment_spec"),
    ?assertMatch([],db_computer:read("math")),
    db_deployment_spec:create(D1), 
    ?assertMatch([{"math","1.0.0",[{"adder_service","1.0.0",1,{host_id,"asus"}}]}],
		 db_deployment_spec:read("math")),

    db_deployment_spec:create(#deployment_spec{id="telldus",vsn="1.0.1",
					       services=[{"tellstick_service","1.2.3",1,{host_id,"asus"}},
							 {"glurk","2.4.1",1,{host_id,"host2"}}]}), 

    ?assertMatch([{"math","1.0.0",[{"adder_service","1.0.0",1,{host_id,"asus"}}]},
		  {"telldus","1.0.1",[{"tellstick_service","1.2.3",1,{host_id,"asus"}},
				      {"glurk","2.4.1",1,{host_id,"host2"}}]}],db_deployment_spec:read_all()),

    db_deployment_spec:update("math","1.0.0","2.0.0",
			      [{"adder_service","1.2.0",1,{host_id,"host2"}}]),

    ?assertMatch([{"math","2.0.0",[{"adder_service","1.2.0",1,{host_id,"host2"}}]},
		  {"telldus","1.0.1",[{"tellstick_service","1.2.3",1,{host_id,"asus"}},
				      {"glurk","2.4.1",1,{host_id,"host2"}}]}],db_deployment_spec:read_all()),

    db_deployment_spec:delete("telldus","1.0.1"),
    ?assertMatch([{"math","2.0.0",[{"adder_service","1.2.0",1,{host_id,"host2"}}]}],db_deployment_spec:read_all()),

     ok.
  
    % Deploy math.deployment
    
    % 1. Identfy instances to deploy

    
    % 2. Identfy service to deploy
 

    % 3. Get path to Service repo

   
    % 4. Get a vm from db_computer to load on 

    


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
db_service_discovery_test()->
    ?assertMatch([],db_service_discovery:read("adder_service")),
    db_service_discovery:create(#service_discovery{id="adder_service",vm='30000@host1'}),
    ?assertMatch(['30000@host1'],
		 db_service_discovery:read("adder_service")),
    db_service_discovery:create(#service_discovery{id="adder_service",vm='30000@host2'}),

    ?assertMatch(['30000@host1','30000@host2'],
		 db_service_discovery:read("adder_service")),
    db_service_discovery:delete("adder_service",'30000@host1'),
    ?assertMatch(['30000@host2'],db_service_discovery:read("adder_service")),

    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

db_computer()->
    % db_computer
    {ok,[C1]}=file:consult("configs/asus.computer"),
    ?assertMatch([],db_computer:read("asus")),
    db_computer:create(C1), 
    ?assertMatch([{"asus","pi","festum01",
		  "192.168.0.100",60100}],db_computer:read("asus")),
    db_computer:create(#computer{host_id="controller_0",ssh_uid="pi2",ssh_passwd="passwd2",
			     ip_addr="192.168.0.213",port=6200}), 
    db_computer:update("asus","pi","glurk",
		  "192.168.0.100",3030),
    ?assertMatch([{"asus","pi","glurk","192.168.0.100",3030}],db_computer:read("asus")),
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

db_service_def()->
     % db_service_def
    {ok,[D1]}=file:consult("configs/adder.service_def"),
    ?assertMatch([],db_computer:read("adder_service")),
    db_service_def:create(D1), 
    ?assertMatch([{"adder_service","1.2.3",
		   "https://github.com/joq62/"}],db_service_def:read("adder_service")),
    db_service_def:create(#service_def{id="divi_service",vsn="1.0.0",
				      source="https://github.com/joq62/"}), 
    db_service_def:update("adder_service","1.2.3","2.0.0", "https://github.com/joq62/"),
    ?assertMatch([{"adder_service","2.0.0",
		   "https://github.com/joq62/"}],db_service_def:read("adder_service")),
    db_service_def:create(#service_def{id="divi_service",vsn="1.2.0",
				       source="https://github.com/joq62/"}), 
    ?assertMatch([{"adder_service","2.0.0","https://github.com/joq62/"},
		  {"divi_service","1.0.0","https://github.com/joq62/"},
		  {"divi_service","1.2.0","https://github.com/joq62/"}],db_service_def:read_all()),

    db_service_def:update("divi_service","1.0.0","1.0.0","glurk"),
    ?assertMatch([{"divi_service","1.2.0","https://github.com/joq62/"},
		  {"divi_service","1.0.0","glurk"}],db_service_def:read("divi_service")),
    
    db_service_def:delete("divi_service","1.0.0"),
    ?assertMatch([{"adder_service","2.0.0","https://github.com/joq62/"},
		  {"divi_service","1.2.0","https://github.com/joq62/"}],db_service_def:read_all()),

     ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
