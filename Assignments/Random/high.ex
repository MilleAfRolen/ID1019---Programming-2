defmodule High do


    def foo(x) do
        y = 3
        fn (v) -> v + x + y end
    end

    def hej() do
        f = foo(2); x = 5; y = 7; f.(1)
    end

    def hej2() do
        x=2; f = fn(y) -> x+y end; f.(4)
    end

    def foldr([], acc, _op) do acc end
    def foldr([h|t], acc, op) do
        op.(h, foldr(t, acc, op))
    end

    def gurka(l) do
        f = fn (_, a) -> a + 1 end
        foldr(l, 0, f)
    end

    def infinity() do
        fn() -> infinity(0) end
    end
    def infinity(n) do
        [n | fn() -> infinity(n+1) end]
    end

    def fib() do
        fn() -> fib(1,1) end
    end
    def fib(f1, f2) do
        [f1 | fn() -> fib(f2, f1+f2) end]
    end

    def sum(range) do
        reduce(range, {:cont, 0}, fn(x, acc) -> {:cont, x + acc} end)
    end

    def prod(range) do
        reduce(range, {:cont, 1}, fn(x, acc) -> {:cont, x * acc} end)
    end

    def take(range, n) do
        reduce(range, {:cont, {:sofar, 0, []}},
            fn (x, {:sofar, s, acc}) -> 
                s = s+1
                if s >= n do
                    {:halt, Enum.reverse([x|acc])}
                else
                    {:cont, {:sofar, s, [x|acc]}}
                end
            end
        )
    end

    def head(range) do
        reduce(range, {:cont, :na}, fn (x, _) -> {:suspend, x} end)
    end
    def reduce(range, {:suspend, acc}, fun) do
        {:suspended, acc, fn(cmd) -> reduce(range, cmd, fun) end}
    end
    def reduce(_, {:halt, acc}, _) do
        {:halted, acc}
    end
    def reduce({:range, from, to}, {:cont, acc}, fun) do
        if from <= to do
            reduce({:range, from+1, to}, fun.(from, acc), fun)
        else
            {:done, acc}
        end
    end
end