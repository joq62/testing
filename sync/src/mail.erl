%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : Simple mail server , main use to send info or alarm from eventhandler
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(mail).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(TIMEOUT, 5000).
-define (VERSION,'0.0.99').
%% --------------------------------------------------------------------
%% External exports
-export([send_mail/6,ver/0]).


ver()-> {?MODULE,?VERSION}.
%% --------------------------------------------------------------------
%% Function: send_mail 
%% Pameters: 
%%       Subject: Subject string in the email , ex "Message from event"
%%       Msg: email body text "Event 1.\n Following actions requires \n"
%%       Receiver: email address to receiver ex,"joakim.leche@gmail.com"
%%       Sender: email of sender ex, "joq.erlang@gmail.com"
%% 
%% Description: Sends one  email
%% Returns: {reply, Reply, State}     
%%      
%% --------------------------------------------------------------------

send_mail(Subject,Msg,Receiver,Sender,UserId,PassWd)->
%Connect
    application:start(crypto),
    application:start(asn1),
    application:start(public_key),
    application:start(ssl),
    {ok, Socket} = ssl:connect("smtp.gmail.com", 465, [{active, false}], ?TIMEOUT),
    recv(Socket),
    send(Socket, "HELO localhost"),
    send(Socket, "AUTH LOGIN"),
    _Re_UId = send(Socket, binary_to_list(base64:encode(UserId))), 
    _RE_Passw = send(Socket, binary_to_list(base64:encode(PassWd))),  
%send mail
    send(Socket, "MAIL FROM:<" ++ Sender ++ ">"),
    send(Socket, "RCPT TO:<" ++ Receiver ++ ">"),
    send(Socket, "DATA"),
    send_no_receive(Socket,"From:<" ++ Sender ++ ">"),
    send_no_receive(Socket,"To:<" ++ Receiver ++ ">"),       
    send_no_receive(Socket, "Date: " ++ date_mail() ++ "Time :" ++ time_mail() ),  
    send_no_receive(Socket, "Subject:" ++ Subject),
    send_no_receive(Socket, ""),
    send_msg(Socket,Msg),
    send(Socket, "."),
%disconnect
    send(Socket, "QUIT"),
    ssl:close(Socket),
    {ok,send_mail}.


%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

send_msg(Socket,Msg)->
    send_no_receive(Socket,Msg). 

send_no_receive(Socket, Data) ->
    ssl:send(Socket, Data ++ "\r\n").

send(Socket, Data) ->
    ssl:send(Socket, Data ++ "\r\n"),
    recv(Socket).

recv(Socket) ->
    case ssl:recv(Socket, 0, ?TIMEOUT) of
	{ok, Return} -> 
	    io:format("~p~n", [Return]);
	{error, Reason} -> 
	    io:format("ERROR: ~p~n", [Reason])
    end.

date_mail()->
    {Y,M,D}=erlang:date(),
    Date = integer_to_list(Y) ++ "-" ++ integer_to_list(M) ++ "-" ++ integer_to_list(D),
    Date.
time_mail()->
    {H,M,S}=erlang:time(),
    Time = integer_to_list(H) ++ "-" ++ integer_to_list(M) ++ "-" ++ integer_to_list(S),
    Time.   


