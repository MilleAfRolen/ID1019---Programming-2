defmodule Shunt do
    alias Train
    alias Moves

    def split(list, atom) do
        case Train.member(list, atom) do
            false -> :sus
            true -> {Train.take(list, Train.position(list, atom)-1), Train.drop(list, Train.position(list, atom))}
        end
    end

    def find(xs, ys) do
        case ys do
            [] -> []
            [h|t] -> 
                {hs, ts} = split(xs, h)
                Moves.single({:one, length(h)}, [], [])
        end

    end


end