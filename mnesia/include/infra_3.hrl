-record(computer,
	{
	  host_id,
	  ssh_uid,
	  ssh_passwd,
	  ip_addr,
	  port
	}).


-record(service_def,
	{
	  id,
	  vsn,
	  git_path
	}).

-record(deployment_spec,
	{
	  id,   %"etcd_0"
	  vsn,  %"1.0.0"
	  services % [{service_id,vsn,num,options}]
	}).
-record(deployment,
	{
	  deployment_id,
	  deployment_vsn,
	  service_def,
	  service_vsn,
	  vm
	}).
-record(service_discovery,
	{
	  id,
	  vms
	}).
