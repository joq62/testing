%%% Copyright 2009 Andrew Thompson <andrew@hijacked.us>. All rights reserved.
%%%
%% @doc Some functions for working with binary strings.

-module(start_mail).

-export([start/0
]).

start()->

 %   ok=application:start(mail),
  %  mail:connect("service.varmdo@gmail.com","Festum01"),
    mail:send_mail("Subject:Test message ","Test message.\n", "joakim.leche@gmail.com","service.varmdo@gmail.com","Festum01").
