-module(etcd).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("node.hrl").


init()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(node, [{attributes, record_info(fields, node)}]),
    mnesia:stop().

create_table(Table,TableArgs)->
    mnesia:create_table(Table, TableArgs).

start(Tables) ->
  mnesia:start(),
  mnesia:wait_for_tables(Tables, 20000).

create_node_item(NodeRecord) ->
    
  %  NodeRecord = #node{host_id=HostId,vsn=Vsn,ip_addr=IpAddr,ssh_id=SshId,ssh_pwd=SshPwd,
%		       vm_id=VmId,capability=Capability},
    F = fun() -> mnesia:write(NodeRecord) end,
    mnesia:transaction(F).


%create_node_item({node,{host_id,HostId},{vsn,Vsn},{ip_addr,IpAddr},{ssh_id,SshId},{ssh_pwd,SshPwd},
%		   {vm_id,VmId},{capability,Capability}}) ->
    
 %   NodeRecord = #node{host_id=HostId,vsn=Vsn,ip_addr=IpAddr,ssh_id=SshId,ssh_pwd=SshPwd,
%		       vm_id=VmId,capability=Capability},
 %   F = fun() -> mnesia:write(NodeRecord) end,
  %  mnesia:transaction(F).



read_all(Table) ->
  do(qlc:q([X || X <- mnesia:table(Table)])).


read_node(HostId) ->
    do(qlc:q([X || X <- mnesia:table(node),
		   X#node.host_id==HostId])).


update_node_item({node,{host_id,HostId},{vsn,Vsn},{ip_addr,IpAddr},{ssh_id,SshId},{ssh_pwd,SshPwd},
		   {vm_id,VmId},{capability,Capability}})->
    F = fun() ->
		Oid = {node, HostId},
		mnesia:delete(Oid),
		NodeRecord = #node{host_id=HostId,vsn=Vsn,ip_addr=IpAddr,ssh_id=SshId,ssh_pwd=SshPwd,
				   vm_id=VmId,capability=Capability},
		mnesia:write(NodeRecord)
	end,
    mnesia:transaction(F).

delete_node_item(HostId) ->
  Oid = {node, HostId},
  F = fun() -> mnesia:delete(Oid) end,
  mnesia:transaction(F).

reset_tables(Table,TableInfo) ->
    mnesia:clear_table(Table),
    F = fun() -> foreach(fun mnesia:write/1, TableInfo) end,
 %  F = fun() -> foreach(fun mnesia:write/1, example_tables()) end,
  mnesia:transaction(F).

do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

%%-------------------------------------------------------------------------
