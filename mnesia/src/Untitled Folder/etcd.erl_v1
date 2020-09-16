-module(etcd).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("node.hrl").

-record(shop, {item, quantity, cost}).
-record(cost, {name, price}).
-record(design, {id, plan}).


init()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(node,   [{attributes, record_info(fields, node)}]),
    mnesia:stop().

start(Tables) ->
  mnesia:start(),
  mnesia:wait_for_tables(Tables, 20000).

create_node_item({node,{host_id,HostId},{vsn,Vsn},{ip_addr,IpAddr},{ssh_id,SshId},{ssh_pwd,SshPwd},
		   {vm_id,VmId},{capability,Capability}}) ->
    
    NodeRecord = #node{host_id=HostId,vsn=Vsn,ip_addr=IpAddr,ssh_id=SshId,ssh_pwd=SshPwd,
		       vm_id=VmId,capability=Capability},
    F = fun() -> mnesia:write(NodeRecord) end,
    mnesia:transaction(F).



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
demo(reorder) ->
  do(qlc:q([X#shop.item || X <- mnesia:table(shop), X#shop.quantity < 250]));

demo(join) ->
  do(qlc:q([X#shop.item || X <- mnesia:table(shop), 
    X#shop.quantity < 250,

    Y <- mnesia:table(cost),
    X#shop.item =:= Y#cost.name,
    Y#cost.price < 2])).



example_tables() ->
  [
  {shop, apple,  20,   2.3},
  {shop, orange, 100,  3.8},
  {shop, pear,   200,  3.6},
  {shop, banana, 420,  4.5},
  {shop, potato, 2456, 1.2},

  {cost, apple,  1.5},
  {cost, orange, 2.4},
  {cost, pear,   2.2},
  {cost, banana, 1.5},
  {cost, potato, 0.6}
  ].

add_shop_item(Name, Quantity, Cost) ->
  Row = #shop{item=Name, quantity=Quantity, cost=Cost},
  F = fun() -> mnesia:write(Row) end,
  mnesia:transaction(F).

remove_shop_item(Item) ->
  Oid = {shop, Item},
  F = fun() -> mnesia:delete(Oid) end,
  mnesia:transaction(F).

farmer(Nwant) ->
  F = fun() ->
    [Apple] = mnesia:read({shop, apple}),
    NApples = Apple#shop.quantity,
    Apple1  = Apple#shop{quantity = NApples + 2 * Nwant},
    mnesia:write(Apple1),
    [Orange] = mnesia:read({shop, orange}),
    NOrange = Orange#shop.quantity,
    if
      NOrange >= Nwant -> 
        N1 = NOrange - Nwant,
        Orange1 = Orange#shop{quantity=N1},
        mnesia:write(Orange1);
      true -> mnesia:abort(oranges)
    end
  end,
  mnesia:transaction(F).



add_plans() ->
  D1 = #design{id = {joe, 1},            plan = {circle, 10}},
  D2 = #design{id = fred,                plan = {rectangle, 10, 5}},
  D3 = #design{id = {jane, {house, 23}}, plan = {house, [
  {floor, 1, [{doors, 3}, {window, 2}, {room, 5}]}, 
  {floor, 2, [{doors, 2}, {rooms,  4}, {windows, 15}]}]}},
  F = fun() ->
    mnesia:write(D1),
    mnesia:write(D2),
    mnesia:write(D3)
  end,
  mnesia:transaction(F).

get_plan(PlanId) ->
  F = fun() -> mnesia:read({design, PlanId}) end,
mnesia:transaction(F).
