defmodule Lumber do


    def split(seq) do split(seq, 0, [], []) end

    def split([], l, left, right) do
        [{left, right, l}]
    end
    def split([s|rest], l, left, right) do
        split(rest, l+s, [s|left], right) ++ split(rest, l+s, left, [s|right])
    end


    def cost([]) do 0 end
    def cost([h]) do {0, h} end
    def cost(seq) do cost(seq, 0, [], []) end

    def cost([], l, left, right) do
        {cl, tl} = cost(left)
        {cr, tr} = cost(right)
        {cl+cr+l, {tl, tr}}
    end
    def cost([s], l, [], right) do
        {cr, tr} = cost(right)
        {cr+l+s, {s, tr}}
    end
    def cost([s], l, left, []) do
        {cl, tl} = cost(left)
        {cl+l+s, {s, tl}}
    end


    def cost([s|rest], l, left, right) do
        {costl, tl} = cost(rest, l+s, [s|left], right)
        {costr, tr} = cost(rest, l+s, left, [s|right])
        
        if costl < costr do
            {costl, tl}
        else
            {costr, tr}
        end
    end

    def cost2([]) do {0, :na} end
    def cost2(seq) do
        {cost, tree, _} = cost2(Enum.sort(seq), Memo.new())
        {cost, tree}
    end
    def cost2([s], mem) do {0, s, mem} end
    def cost2([s|rest]=seq, mem) do
        {c, t, mem} = cost2(rest, s, [s], [], mem)
        {c, t, Tree.add(mem, seq, {c, t})}
    end
    def cost2([], l, left, right, mem) do
        {cl, tl, mem} = check(Enum.reverse(left), mem)
        {cr, tr, mem} = check(Enum.reverse(right), mem)
        {cr+cl+l, {tl, tr}, mem}
    end
    def cost2([s], l, left, [], mem) do
        {c, t, mem} = check(Enum.reverse(left), mem)
        {c+s+l, {t, s}, mem}
    end
    def cost2([s], l, [], right, mem) do
        {c, t, mem} = check(Enum.reverse(right), mem)
        {c+s+l, {t, s}, mem}
    end

    def cost2([s|rest], l, left, right, mem) do
        {cl, tl, mem} = cost2(rest, l+s, [s|left], right, mem)
        {cr, tr, mem} = cost2(rest, l+s, left, [s|right], mem)
        if cl < cr do
            {cl, tl, mem}
        else
            {cr, tr, mem}
        end
    end
    
    def check(seq, mem) do
        case Tree.lookup(mem, seq) do
            nil -> 
                cost2(seq, mem)
            {c, t} -> 
                {c, t, mem}
        end
    end

    def bench(n) do
        for i <- 1..n do
            {t,_} = :timer.tc(fn() -> cost2(Enum.to_list(1..i)) end)
            IO.puts(" n = #{i}\t t = #{t} us")
        end
    end
end

defmodule Memo do

    def new() do %{} end

    def add(mem, key, val) do Map.put(mem, :binary.list_to_bin(key), val) end

    def lookup(mem, key) do Map.get(mem, :binary.list_to_bin(key)) end

end

defmodule Tree do
    def new() do [] end

    def add(mem, [h], val) do addToTree(mem, h, val) end
    def add(mem, [h|t], val) do add(mem, h, t, val) end 

    def add([], h, rest, value) do [{h, nil, add([], rest, value)}] end
    def add([{h, val, branch}|mem], h, rest, value) do [{h, val, add(branch, rest, value)}|mem] end  
    def add([first|mem], h, rest, value) do [first| add(mem, h, rest, value)] end  				   

    def addToTree([], h, val) do [{h, val, []}] end
    def addToTree([{h, nil, branch}|mem], h, val) do [{h, val, branch}|mem] end  
    def addToTree([first|mem], h, val) do [first| insert(mem, h, val)] end  

    def lookup([], _) do nil end
    def lookup(mem, [h]) do val(mem, h) end
    def lookup(mem, [h|t]) do lookup(mem, h, t) end

    def lookup([], _, _) do nil end
    def lookup([{h, _, branch}|_], h, t) do lookup(branch, t) end
    def lookup([_|mem], h, t) do lookup(mem, h, t) end    

    def val([], _) do nil end
    def val([{n, val, _}|_], n) do val end
    def val([_|t], n) do val(t, n) end   


end
