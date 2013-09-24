start-dev starts a dev erl vm with all of the necessary applications
started for your boot_rel. This saves having to do rebar generate
between minor and static file edits that would otherwise hinder your
productivity.

# How it works

It reads your rel/reltool.config file and starts the relevant
applications in the correct order for the release defined as the
boot_rel. It's as simple as that!

# How to use

    git clone https://github.com/mokele/start.erl
    cd start.erl
    rebar compile

Add the following line to your ~/.erlang file (or create it if you
haven't created one yet)

    code:add_patha("/absolute/path/to/start.erl/ebin").

Symlink or add the start-dev bash script to your path

    ln -s /absolute/path/to/start.erl/start-dev \
          /usr/local/bin/start-dev

Now go to your project and run start-dev

    $ ls
    apps    rebar.config    deps    rel
    $ start-dev
    Erlang R16B01 (erts-5.10.2) [source] ...
  
    Eshell V5.10.2  (abort with ^G)
    1>
    # here your applications are automatically started

You can also specify any other erl flags you like

    $ start-dev -config rel/files/sys.config \
          -name mynode@127.0.0.1 \
          -s lager

# Current limitations
I have only just got this project working to aide me with another
project, so have not continued this through to a more permanent reusable
end, so any help removing this limitations would be awesome for others
who want to make use of start.erl

 * It is assumed your apps are under ./apps/*
 * It is assumed your reltool.config is in ./rel/
 * It is assumed your deps are in ./deps/*
 * sys.config files are not automatically read (template variable
   substitution would be necessary also). It is advised to generated
   a release once, then use -config to specify the sys.config from that
   release if you required template substitutions in your config.
   
