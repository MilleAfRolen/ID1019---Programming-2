defmodule Environment do


def new do [] end


def add(id, str, env) do
    [{id, str} | env]
end

def lookup(_, []) do nil end
def lookup(id, env = [h|t]) do
    {x, _} = h
    cond do
        id == x -> h
        true -> lookup(id, t)
    end

end