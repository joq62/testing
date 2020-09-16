-module(etcd).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("infra_3.hrl").


init()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(computer, [{attributes, record_info(fields, computer)}]),
    mnesia:create_table(service_def, [{attributes, record_info(fields, service_def)}]),
    mnesia:create_table(deployment_spec, [{attributes, record_info(fields, deployment_spec)}]),
    mnesia:create_table( deployment, [{attributes, record_info(fields, deployment)}]),
    mnesia:stop().

create_table(Table,TableArgs)->
    mnesia:create_table(Table, TableArgs).

start(Tables) ->
  mnesia:start(),
  mnesia:wait_for_tables(Tables, 20000).

create(Record) ->
    
  %  NodeRecord = #node{host_id=HostId,vsn=Vsn,ip_addr=IpAddr,ssh_id=SshId,ssh_pwd=SshPwd,
%		       vm_id=VmId,capability=Capability},
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).


%create_node_item({node,{host_id,HostId},{vsn,Vsn},{ip_addr,IpAddr},{ssh_id,SshId},{ssh_pwd,SshPwd},
%		   {vm_id,VmId},{capability,Capability}}) ->
    
 %   NodeRecord = #node{host_id=HostId,vsn=Vsn,ip_addr=IpAddr,ssh_id=SshId,ssh_pwd=SshPwd,
%		       vm_id=VmId,capability=Capability},
 %   F = fun() -> mnesia:write(NodeRecord) end,
  %  mnesia:transaction(F).



read_all(Table) ->
  do(qlc:q([X || X <- mnesia:table(Table)])).


read_computer(HostId) ->
    do(qlc:q([X || X <- mnesia:table(computer),
		   X#computer.host_id==HostId])).

read_service_def(ServiceId) ->
    R=case do(qlc:q([X || X <- mnesia:table(service_def),
		   X#service_def.id==ServiceId])) of
	  []->
	      [];
	  [ServiceDef] ->
	      {ServiceDef#service_def.id,ServiceDef#service_def.vsn,
	       ServiceDef#service_def.git_path}
      end,
    R.

update_computer_item(HostId,SshId,SshPwd,IpAddr,Port)->
    F = fun() ->
		Oid = {computer, HostId},
		mnesia:delete(Oid),
		Record = #computer{host_id=HostId,ssh_uid=SshId,ssh_passwd=SshPwd,
				   ip_addr=IpAddr,port=Port},
		mnesia:write(Record)
	end,
    mnesia:transaction(F).

delete_computer_item(HostId) ->
    Oid = {computer, HostId},
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
