%% -------------------------------------------------------------------
%%
%% basho_bench: Benchmarking Suite
%%
%% Copyright (c) 2009-2010 Basho Techonologies
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------
-module(basho_bench_driver_gpac).

-export([new/1,
         run/4]).

-include("basho_bench.hrl").
-include_lib("kernel/include/logger.hrl").

-record(state, {worker_id}).

%% ====================================================================
%% API
%% ====================================================================

new(Id) ->
    rand:seed(exsplus, erlang:timestamp()),
    {ok, #state{worker_id = Id}}.

run(sim2pc, _KeyGen, _ValueGen, _State=#state{worker_id=_Id})->
    ok;

run(test, _KeyGen, _ValueGen, _State) ->
    ok.
