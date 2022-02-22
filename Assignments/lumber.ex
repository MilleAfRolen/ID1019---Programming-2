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
        {cost, tree, _} = cost2(Enum.sort(seq), Tree.new())
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
  def add(mem, [n], val) do insert(mem, n, val) end
  def add(mem, [n|ns], val) do add(mem, n, ns, val) end

  def add([], n, rest, value) do [{n, nil, add([], rest, value)}] end
  def add([{n, val, sub}|mem], n, rest, value) do [{n, val, add(sub, rest, value)}|mem] end  
  def add([first|mem], n, rest, value) do [first| add(mem, n, rest, value)] end  				   

  def insert([], n, val) do [{n, val, []}] end
  def insert([{n, nil, sub}|mem], n, val) do [{n, val, sub}|mem] end  
  def insert([first|mem], n, val) do [first| insert(mem, n, val)] end  

  def lookup([], _) do nil end
  def lookup(mem, [n]) do val(mem, n) end
  def lookup(mem, [n|ns]) do lookup(mem, n, ns) end

  def lookup([], _, _) do nil end
  def lookup([{n, _, sub}|_], n, ns) do lookup(sub, ns) end
  def lookup([_|mem], n, ns) do lookup(mem, n, ns) end    

  def val([], _) do nil end
  def val([{n, val, _}|_], n) do val end
  def val([_|rest], n) do val(rest, n) end    


end
