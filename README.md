# BEAM Jupyter Kernels Tool

[![Build Status](https://travis-ci.org/filmor/ierl.svg?branch=master)](https://travis-ci.org/filmor/ierl)

`ierl` is a command line tool based on
[erlang-jupyter](https://github.com/filmor/erlang-jupyter) to allow running and
installing Jupyter kernels on the Erlang Virtual Machine written in pure Erlang.

Currently, three kernels have been implemented to the point that they support
running code, compiling modules, and code completion:

## Erlang

Not a full replacement for the built-in shell, yet, as records are not supported
and pseudo-functions like `f` or `l` are not implemented.

## Elixir

Since it's currently impossible to bundle Elixir, it will try to guess the path
by running the Elixir executable, so make sure that Elixir is in your `PATH`
environment variable. It is also possible to override the Elixir installation
path using the `--path` switch on installing the kernel.

The Jupyter Notebook will currently highlight the code as Ruby for lack of a
built-in Elixir mode in CodeMirror, but I will look into bundling 
[codemirror-mode-elixir](https://github.com/optick/codemirror-mode-elixir) in
the future.

## LFE

LFE is completely bundled and can be run without any further installation. The
highlighting is currently just straight Common Lisp, which means quite a few
things are not highlighted correctly (like `defmodule`, `defrecord`, atoms,
etc.).

## Common functionality

All kernels can access the `jup_display` functions to print non-text output (in
particular on the Jupyter Notebook):

    % Print 
    DisplayRef = jup_display:display(#{ html => "<h1>Some Text</h1>" }).

The key of the passed map is either `html`, `text`, or a binary or string
indicating an actual MIME type like `text/html`. The value is an IO list with
data matching the MIME type. A displayed value can be updated within the same
cell by using the returned reference:

    jup_display:update(DisplayRef, #{ html => "<h1>Updated Text</h1>" }).

Currently, the Jupyter Notebook will also update output sections that were
initialised before, but it's not specified, whether this implementation detail
will stay.

# Usage

The released escript can be run directly by either making it executable
(`chmod +x ierl`) and using it directly (`./ierl`) or starting it explicitly
with `escript ierl` (needed on Windows, for example). It will present the
available commands and backends.

To install an Erlang kernel, run

    ./ierl install erlang

Analogously kernels for LFE and Elixir can be installed.

To specify the name of the installed kernelspec, pass it using `--name`. By
default it will match the backend name (so `erlang`, `elixir` or `lfe`).

    ./ierl install erlang --name my_erlang_kernel

Remoting is also supported. Pass the node to connect to via `--node` and the
cookie to use via `--cookie`.

    ./ierl install erlang --node remote_node@REMOTEHOST --cookie my_secret_cookie

If no name is given, it will be inferred from the kernel name and the node the
kernel is supposed to run against.

The installed kernels will be immediately available in the Jupyter Notebook, to
use them in the console run

    jupyter console --kernel my_erlang_kernel


# Building

Clone this repository and run

    ./_download_rebar3.sh

to download the most current [`rebar3`](http://www.rebar3.org). After this, run

    ./rebar3 build

to download the dependencies and compile the `escript`. It will be created in
`_build/default/bin/ierl`.

For development it might make sense to check out a local instance of
[`erlang-jupyter`](https://github.com/filmor/erlang-jupyter) by running

    ./_checkout_jupyter.sh
