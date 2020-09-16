%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(mnesia_test_2).  
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include("infra_2.hrl").
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
    ?debugMsg("Deployment_test"),
    deployment_test(),
  %  ?debugMsg("test_3"),
  %  test_3(),
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
    {ok,D1}=file:consult(filename:join(Path,"math.deployment")),
    Deployment=infra:deployment_record(D1),
    [TargetInstance|_]=Deployment#deployment.instances,
    ?assertMatch("math.instance",TargetInstance),    
    
    % 2. Identfy service to deploy
    {ok,I1}=file:consult(filename:join(Path,TargetInstance)),
    Instance=infra:instance_record(I1),
 %   ?assertMatch({instance,"adder.service_def",1,["asus"]},Instance),
    ServiceDef=Instance#instance.service_def,
    Num=Instance#instance.num,
    [HostId|_]=Instance#instance.options,

    % 3. Get path to Service repo

    {ok,S1}=file:consult(filename:join(Path,ServiceDef)),
    ServiceInfo=infra:service_def_record(S1),
    ServiceId=ServiceInfo#service_def.app_id,
    Vsn=ServiceInfo#service_def.vsn,
    GitPath=ServiceInfo#service_def.git_path,

    % 4. Get a vm from computer to load on 

    ComputerFile=HostId++".computer",
    {ok,C1}=file:consult(filename:join(Path,ComputerFile)),
    Computer=infra:computer_record(C1),
    SshUid=Computer#computer.ssh_uid,
    SshPassWd=Computer#computer.ssh_passwd,
    IpAddr=Computer#computer.ip_addr,
    Port=Computer#computer.port,

    
  %  ?assertMatch({computer,"asus","pi","festum01",
%		  "192.168.0.100",60100},Computer),
 
    %% DEploy Action
 

    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

test_1()->
    {ok,C1}=file:consult("configs/asus.computer"),
    Computer=infra:computer_record(C1),
    ?assertMatch({computer,"asus","pi","festum01",
		  "192.168.0.100",60100},Computer),

    {ok,S1}=file:consult("configs/adder.service_def"),
    ServiceDef=infra:service_def_record(S1),
    ?assertMatch({service_def,"adder_service","1.2.3",
		  "https://github.com/joq62/"},ServiceDef),

    {ok,I1}=file:consult("configs/math.instance"),
    Instance=infra:instance_record(I1),
    ?assertMatch({instance,"adder.service_def",1,["asus"]},Instance),

    {ok,D1}=file:consult("configs/math.deployment"),
    Deployment=infra:deployment_record(D1),
    ?assertMatch({deployment,"math","2.1.3",["math.instance"]},Deployment),
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
