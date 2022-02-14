defmodule Primes do

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
        

    end
end