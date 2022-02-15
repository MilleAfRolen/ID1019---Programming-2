defmodule Primes do

    defstruct [:next]

    defimpl Enumerable do
        def count(_) do {:error, __MODULE__} end
        def member?(_,_) do {:error, __MODULE__} end
        def slice(_) do {:error, __MODULE__} end

        def reduce(_, {:halt, acc}, _) do
            {:halted, acc}
        end
        def reduce(primes, {:suspend, acc}, fun) do
            {:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
        end

        def reduce(primes, {:cont, acc}, fun) do
            {p, next} = Primes.next(primes)
            reduce(next, fun.(p,acc), fun)
        end
    end

    def z(n) do
        fn() -> {n, z(n+1)} end
    end


    def filter(fun, f) do
        {n, fun2} = fun.()
        case rem(n, f) do
            0 -> filter(fun2, f)
            _ -> {n, fn -> filter(fun2, f) end}
        end
    end
    def sieve(fun, p) do
        {n, fun2} = filter(fun, p)
        {n, fn() -> sieve(fun2, n) end}
    end

    def next(%Primes{next: fun}) do
        {n, fun2} = fun.()
        {n, %Primes{next: fun2}}
    end

    def primes() do
        %Primes{next: fn() -> {2, fn() -> sieve(z(3), 2) end} end}
    end

    def primesOld() do
        fn() -> {2, fn() -> sieve(z(3), 2) end} end
    end
end