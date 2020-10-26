%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(mnesia_test).  
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include("node.hrl").
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
 %   ?debugMsg("test_1"),
 %   test_1(),
  %  ?debugMsg("test_2"),
  %  test_2(),
    ?debugMsg("test_3"),
    test_3(),
    ok.




%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
test_3()->
    etcd:start([node]),
    {ok,[Info]}=file:consult("configs/asus.node"),
    {node,{host_id,HostId},{vsn,Vsn},{ip_addr,IpAddr},{ssh_id,SshId},{ssh_pwd,SshPwd},
     {vm_id,VmId},{capability,Capability}}=Info,
    
    etcd:create_node_item(Info),
    ChckInfo=etcd:read_all(node),
    ?assertMatch([{node,"asus","0.0.99","192.168.0.50","pi","festum01","10250",[tellstick]}],ChckInfo),
    {ok,[Info1]}=file:consult("configs/sthlm_1.node"),
    etcd:create_node_item(Info1),
    ChckInfo1=etcd:read_all(node),
    ?assertMatch([{node,"asus","0.0.99","192.168.0.50","pi","festum01","10250",[tellstick]},
		  {node,"sthlm_1","1.0.0","192.168.0.110","pi","festum01","10250",[tellstick]}],ChckInfo1),
   
    %read one node
    AsusInfo=etcd:read_node("asus"),
    ?assertMatch([{node,"asus","0.0.99","192.168.0.50","pi","festum01","10250",[tellstick]}],AsusInfo),

    % Update complete row
    etcd:update_node_item({node,{host_id,"asus"},{vsn,"1.0.0"},{ip_addr,"192.168.0.50"},{ssh_id,"pi"},
			   {ssh_pwd,"festum01"},{vm_id,"30003"},{capability,[]}}),
    AsusInfo1=etcd:read_node("asus"),
    ?assertMatch([{node,"asus","1.0.0","192.168.0.50","pi","festum01","30003",[]}],AsusInfo1),

 % Delete complete 
    etcd:delete_node_item("asus"),
    [ChckInfo2]=etcd:read_all(node),
    ?assertMatch({node,"sthlm_1","1.0.0","192.168.0.110","pi","festum01","10250",[tellstick]},ChckInfo2),
    ?assertMatch("sthlm_1",ChckInfo2#node.host_id),
    
    % Update part record 
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
test_2()->
    etcd:start([node]),
    {ok,[Info]}=file:consult("configs/asus.node"),
    etcd:create_node_item(Info),
    ChckInfo=etcd:read_all(node),
    ?assertMatch([{node,"asus","0.0.99","192.168.0.50","pi","festum01","10250",[tellstick]}],ChckInfo),
    {ok,[Info1]}=file:consult("configs/sthlm_1.node"),
    etcd:create_node_item(Info1),
    ChckInfo1=etcd:read_all(node),
    ?assertMatch([{node,"asus","0.0.99","192.168.0.50","pi","festum01","10250",[tellstick]},
		  {node,"sthlm_1","1.0.0","192.168.0.110","pi","festum01","10250",[tellstick]}],ChckInfo1),
   
    %read one node
    AsusInfo=etcd:read_node("asus"),
    ?assertMatch([{node,"asus","0.0.99","192.168.0.50","pi","festum01","10250",[tellstick]}],AsusInfo),

    % Update complete row
    etcd:update_node_item({node,{host_id,"asus"},{vsn,"1.0.0"},{ip_addr,"192.168.0.50"},{ssh_id,"pi"},
			   {ssh_pwd,"festum01"},{vm_id,"30003"},{capability,[]}}),
    AsusInfo1=etcd:read_node("asus"),
    ?assertMatch([{node,"asus","1.0.0","192.168.0.50","pi","festum01","30003",[]}],AsusInfo1),

 % Delete complete 
    etcd:delete_node_item("asus"),
    [ChckInfo2]=etcd:read_all(node),
    ?assertMatch({node,"sthlm_1","1.0.0","192.168.0.110","pi","festum01","10250",[tellstick]},ChckInfo2),
    ?assertMatch("sthlm_1",ChckInfo2#node.host_id),
    
    % Update part record 
    
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
test_1()->
    etcd:start([node]),
    {ok,Files}=file:list_dir("configs"),
    L1=[file:consult(filename:join("configs",File))||File<-Files,
       ".node"==filename:extension(File)],
    NodeInfo=[Info||{ok,[Info]}<-L1],
   % ?assertMatch(glurk,L2),
    etcd:reset_tables(node,NodeInfo),
    ChckInfo=etcd:read_all(node),
    ?assertMatch([{node,{host_id,"asus"},{vsn,"0.0.99"},{ip_addr,"192.168.0.50"},{ssh_id,"pi"},{ssh_pwd,"festum01"},
		   {vm_id,"10250"},{capability,[tellstick]}},
		  {node,{host_id,"sthlm_1"},{vsn,"1.0.0"},{ip_addr,"192.168.0.110"},{ssh_id,"pi"},{ssh_pwd,"festum01"},
		   {vm_id,"10250"},{capability,[tellstick]}}],ChckInfo),
    ok.



%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

