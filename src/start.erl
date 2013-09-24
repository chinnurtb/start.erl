-module(start).

-export([start/0]).

start() ->
  {ok, [{sys, Sys}|_]} = file:consult("rel/reltool.config"),
  {value, {boot_rel, BootRel}} = lists:keysearch(boot_rel, 1, Sys),
  {value, {rel, BootRel, _Vsn, Apps}} = lists:keysearch(BootRel, 2, Sys),

  SortedAppList = sort(deps(Apps, Apps, [])),
  lists:foreach(fun application:start/1, SortedAppList),
  ok.

deps([], _Apps, AppsWithDeps) ->
  AppsWithDeps;
deps([App|T], Apps, AppsWithDeps) ->
  Ebin = code:lib_dir(App, ebin),
  AppL = atom_to_list(App),
  AppFile = filename:join(Ebin, AppL ++ ".app"),
  {ok, [{application, App, Opts}]} = file:consult(AppFile),

  Deps = proplists:get_value(applications, Opts, []),
  NewApps = lists:subtract(Deps, Apps),
  deps(T ++ NewApps,
       Apps ++ NewApps,
       [{App, Deps}|AppsWithDeps]).

sort(AppsWithDeps) ->
  [App || {App, _} <- lists:usort(fun sort/2, AppsWithDeps)].

sort({App1, _Deps1}, {_App2, Deps2}) ->
  lists:member(App1, Deps2).
