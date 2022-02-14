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

    #[2,3,5,7,11,13,17,19,23,29,31]
    def sieve(fun, p) do
        {n, fun2} = filter(fun, p)
        {n, fn() -> filter(fun2, n) end}


    end
end