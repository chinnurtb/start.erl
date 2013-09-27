-module(start).

-export([start/0]).

start() ->
  {ok, [{sys, Sys}|_]} = file:consult("rel/reltool.config"),
  {value, {boot_rel, BootRel}} = lists:keysearch(boot_rel, 1, Sys),
  {value, {rel, BootRel, _Vsn, Apps}} = lists:keysearch(BootRel, 2, Sys),

  SortedAppList = sort(deps(Apps, Apps, [])),
  lists:foreach(fun(App) ->
        case application:start(App) of
          ok -> ok;
          {error, {already_started, App}} -> ok
        end
    end, SortedAppList).

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
  [App || {App, _} <- lists:sort(fun sort/2, AppsWithDeps)].

sort({App1, Deps1}, {App2, Deps2}) ->
  M = lists:member(App1, Deps2),
  if
    not M ->
      not lists:member(App2, Deps1);
    true ->
      M
  end.
