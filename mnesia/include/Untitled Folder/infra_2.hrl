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

-record(instance,
	{
	  service_def, 
	  num,       % num of instances om differet computers
	  options    %[nodes]|[]
	}).

-record(deployment,
	{
	  id,   %"etcd_0"
	  vsn,  %"1.0.0"
	  
	instances %[instances]
	}).


