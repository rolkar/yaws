%% This function aims at replacing simple and direct substitution traditionaly
%% done with SED in Unix makefile
%% Take the name of an Input file and output file.
%% It is usefull when you have template (for example starting scripts)
%% that need some substitution during the build of the project.
%% Substitution are expressed as a list of tuples of the form {"Regexp", "Replacement string"}

-module('sed').
-export([s/1]).

s([In|Params]) ->
    s(In, Params),
    erlang:halt().
s(In,[Out|Params]) ->
    case to_list(Params,[],[]) of
    error -> 1;
    Substs -> 
        io:format("Creating ~p~n",[Out]),
        subst(In, Out, Substs)
    end.
%% Transform 
to_list([H|T], [], Substs) ->
    to_list(T,H,Substs);
to_list([H|T], P, Substs) ->
    to_list(T,[],lists:append(Substs,[{P,H}]));
to_list([],[],Substs) ->
    Substs;
to_list([],_P,_Substs) ->
    error.
    
%% Load file, perform substitution, save new file
subst(InFile, OutFile, ListOfSubsts) ->
    %% Read the file as a binary.
    {ok, Bin} = file:read_file(InFile),
    String = binary_to_list(Bin),
    NewString = perform_all_substs(String, ListOfSubsts),
    NewBin = list_to_binary(NewString),
    file:write_file(OutFile, NewBin),
    0.

perform_all_substs(String, []) ->
    String;
perform_all_substs(String, [Subst|Substs]) ->
    {Regexp, NewStr} = Subst,
    %% change from regexp:gsub to internal gsub	
    case cgRegexp:gsub(String, Regexp, NewStr) of
    {ok, NewString, _RepCount} ->
        perform_all_substs(NewString, Substs);
    {error, Error} ->
        io:format("Error in Regexp: ~p~n", [Error]),
        perform_all_substs(String, Substs)
    end.