defmodule Prim do

    def first(_, []) do [] end
    def first(n) do
        [h|t] = Enum.to_list(2..n)
        [h | first(h, t)]
    end
    def first(x, [h|t]) do
        cond do
            rem(h, x) == 0 -> first(x, t)
            t == [] -> [h|t]
            true -> [h | first(x, t)]
        end
    end

    def second(_, [], _) do [] end
    def second(n) do
        [h|t] = Enum.to_list(2..n)
        second([h|t], [])
    end
    def second([h|t], primes = []) do
        findPrime(t, [h], [h])
    end

    def findPrime([], _, savedPrimes) do savedPrimes end
    def findPrime([h|t], [], savedPrimes) do findPrime(t, savedPrimes ++ [h], savedPrimes ++ [h]) end
    def findPrime([h|t],primes = [h2|t2], savedPrimes) do
        cond do
            rem(h, h2) == 0 -> findPrime(t, savedPrimes, savedPrimes)
            rem(h, h2) != 0 -> findPrime([h|t], t2, savedPrimes)
        end
    end

    def third(_, [], _) do [] end
    def third(n) do
        [h|t] = Enum.to_list(2..n)
        third([h|t], [])
    end
    def third([h|t], primes = []) do
        findPrimes(t, [h], [h])
    end

    def findPrimes([], _, savedPrimes) do Enum.reverse(savedPrimes) end
    def findPrimes([h|t], [], savedPrimes) do findPrimes(t, [h] ++ savedPrimes, [h] ++ savedPrimes) end
    def findPrimes([h|t],primes = [h2|t2], savedPrimes) do
        cond do
            rem(h, h2) == 0 -> findPrimes(t, savedPrimes, savedPrimes)
            rem(h, h2) != 0 -> findPrimes([h|t], t2, savedPrimes)
        end
    end


end