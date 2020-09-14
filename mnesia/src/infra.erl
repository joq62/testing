-module(infra).

-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("infra_2.hrl").


computer_record([{host_id,HostId},{ssh_uid,SshId},{ssh_passwd,SshPasswd},{ip_addr,IpAddr},{port,Port}])->
    #computer{host_id=HostId,ssh_uid=SshId,ssh_passwd=SshPasswd,ip_addr=IpAddr,port=Port}.

service_def_record([{app_id,AppId},{vsn,Vsn},{git_path,GitPath}])->
    #service_def{app_id=AppId,vsn=Vsn,git_path=GitPath}.

instance_record([{service_def,ServiceDef},{num,Num},{options,Options}])->
    #instance{service_def=ServiceDef,num=Num,options=Options}.

deployment_record([{id,Id},{vsn,Vsn},{instances,Instances}])->
    #deployment{id=Id,vsn=Vsn,instances=Instances}.

