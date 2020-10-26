-module(db_deployment).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("infra_3.hrl").

-define(TABLE,deployment).
-define(RECORD,deployment).

start() ->
  %  mnesia:create_schema([node()]), %Should be started by db_mnesia
  %  mnesia:start(),
%    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)}]),
 %   mnesia:wait_for_tables(?TABLE, 20000).   %Should be started by db_mnesia
    ok.
create_table()->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)}]),
    mnesia:wait_for_tables(?TABLE, 20000).

create(Record) ->
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).

read_all() ->
  do(qlc:q([X || X <- mnesia:table(?TABLE)])).



read(Id) ->
    do(qlc:q([X || X <- mnesia:table(?TABLE),
		   X#?RECORD.id==Id])).


update(Id,Vsn,ServiceId,ServiceVsn,Vm)->
    F = fun() ->
		Oid = {?TABLE, Id},
		mnesia:delete(Oid),
		Record = #?RECORD{id=Id,vsn=Vsn,service_id=ServiceId,service_vsn=ServiceVsn,vm=Vm},
		mnesia:write(Record)
	end,
    mnesia:transaction(F).

delete(Id) ->
    Oid = {?TABLE,Id},
    F = fun() -> mnesia:delete(Oid) end,
  mnesia:transaction(F).


do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

%%-------------------------------------------------------------------------
