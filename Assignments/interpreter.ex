defmodule Env do


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

    def remove(ids, env=[h|t]) do #int klar
        {x, _} = h
        cond do
            ids == x -> t
            true -> remove(ids, t)
        end
    end
end