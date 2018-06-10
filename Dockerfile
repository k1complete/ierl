FROM jupyter/minimal-notebook:59904dd7776a

USER root

# Erlang
# Install Erlang Solutions repository
RUN apt-get update && \
    apt-get install -y gnupg2 curl apt-utils && \
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    rm erlang-solutions_1.0_all.deb && \
    apt-get update && \
    apt-get install -y erlang elixir && \
    mix local.hex --force && \
    mix local.rebar --force

USER $NB_USER

# Erlang, LFE and Elixir
RUN git clone --depth 1 https://github.com/filmor/ierl.git && \
    cd ierl && \
    mkdir /home/$NB_USER/.ierl && \
    mix deps.get && \
    env MIX_ENV=prod mix escript.build && \
    cp ierl /home/$NB_USER/.ierl/ierl.escript && \
    chmod +x /home/$NB_USER/.ierl/ierl.escript && \
    /home/$NB_USER/.ierl/ierl.escript install erlang --user && \
    /home/$NB_USER/.ierl/ierl.escript install lfe --user && \
    /home/$NB_USER/.ierl/ierl.escript install elixir --user && \
    cd .. && \
    rm -rf ierl
