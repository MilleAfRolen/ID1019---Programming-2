defmodule Test do

    def double(n) do
        2*n;
    end

    def convert(f) do
        (f - 32)/1.8;
    end

    def rectangle(b, h) do
        b*h;
    end

    def square(s) do
        rectangle(s,s);
    end

    def circle(r) do
        r*r*3.1415;
    end

end

defmodule Recursion do

    def product(m, n) do
        if m == 0 do
            0;
        else
            n + product(m-1, n);
        end
    end

    def product_case(m, n) do
        case m do
            0 ->
            0;
            _ ->
            n + product_case(m-1, n);
        end
    end

    def product_cond(m, n) do
        cond do
            m == 0 ->
            0;
            true ->
            n + product_cond(m-1, n);
        end
    end

    def product_clauses(0, _) do 0 end
    def product_clauses(m, n) do
        product(m-1, n) + n;
    end

    def exp(x, n) do
        case n do
            0 ->
            1;
            1 ->
            x;
            _ ->
            product(x, exp(x, n-1));
        end
    end

    def exp2(x, n) do
        cond do
            n == 1 ->   x
            rem(n, 2) == 0 ->
                exp2(x, div(n,2)) * exp2(x, div(n,2))
            rem(n, 2) == 1 ->
                exp2(x, n-1) * x
        end
    end
end

defmodule Lists do

    def nth(n, [head|tail]) do
        case n do
        0 -> head
        _ -> nth(n-1, tail)
        end
    end
    
    def len([]) do 0 end
    def len([_|tail]) do
        1 + len(tail)
    end

    def sum([]) do 0 end
    def sum([head|tail]) do
        head + sum(tail)
    end

    def duplicate([head|tail]) do
        case tail do
            [] -> [head, head]
            _ -> [head | [head | duplicate(tail)]]
        end    
    end
    
    def add(x, []) do [x] end
    def add(x, [head|tail]) do
        cond do
            head == x -> [head|tail]
            tail == [] -> [head|[x|tail]]
            true -> [head | add(x, tail)]
        end
    end

    def remove(_, []) do [] end
    def remove(x, [head|tail]) do
        cond do
            head == x -> remove(x, tail)
            tail == [] -> [head|tail]
            true -> [head | remove(x, tail)]
        end
    end

    def unique([]) do [] end
    def unique([head|tail]) do
        [head | unique(remove(head, tail))]
    end

    def pack([]) do [] end
    def pack([h|t]) do
        [[h | pack(h,t)] | pack(remove(h,t))]
    end
    def pack(_, []) do [] end
    def pack(h, [h|t]) do
        [h|pack(h,t)]
    end
    def pack(h,[_|t]) do
        pack(h,t)
    end
    
    def reverse([]) do [] end
    def reverse([head|tail]) do
        reverse(tail) ++ [head]
    end

    def insert(element, []) do [element] end
    def insert(element, [h|t]) do
        cond do
            element < h -> [element | [h | t]]
            element >= h -> [h | insert(element, t)]
        end
    end

    def iSort(l) do
        iSort(l, [])
    end
    def iSort(l, sorted) do
        case l do
            [] -> sorted
            [h|t] -> iSort(t, insert(h, sorted))
        end
    end

    def iSort2(l) do
        iSort2(l, [])
    end
    def iSort2([], sorted) do sorted end
    def iSort2([h|t], sorted) do
        iSort2(t, insert(h, sorted))
    end

    def msort(l) do
        case l do
            [] -> []
            [h] -> [h]
            [_|_] -> {low, high} = msplit(l, [], [])
            merge(msort(low), msort(high))
        end
    end
    
    def merge(low, []) do low end 
    def merge([], high) do high end
    def merge(low = [h1|t1], high = [h2|t2]) do 
        if h1 < h2 do
            [h1 | merge(t1, high)]
        else
            [h2 | merge(low, t2)]
        end
    end

    def msplit(l, low, high) do
        case l do
            [] -> {low, high}
            [h|t] -> msplit(t, [h | high], low)
        end
    end
end


