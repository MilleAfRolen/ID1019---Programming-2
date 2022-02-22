defmodule Train do

    #returns list containing first n elements
    def take(_, 0) do [] end
    def take([h|t], n) do
        [h | take(t, n-1)]
    end

    #returns list without its first n elements
    def drop(xs, 0) do xs end
    def drop([_|t], n) do
        drop(t, n-1)
    end

    def append(xs, ys) do
        xs ++ ys
    end

    def member([], _) do false end
    def member([h|t], y) do
        cond do
            h == y -> true
            true -> member(t, y)
        end
    end

    def position([], _) do :knas end
    def position([h|t], y) do
        cond do
            h == y -> 1
            true -> 1 + position(t, y)
        end
    end
end