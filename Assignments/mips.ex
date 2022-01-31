defmodule Emulator do


    def run(prgm) do
        {code, data} = Program.load(prgm)
        out = Out.new()
        reg = Register.new()
        run(0, code, reg, data, out)
    end

    def run(pc, code, reg, mem, out) do
        next = Program.read_instruction(code, pc)
        case next do
            :halt -> Out.close(out)

            {:out, rs} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                out = Out.put(out, s)
                run(pc, code, reg, mem, out)

            {:add, rd, rs, rt} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                reg = Register.write(reg, rd, s + t)
                run(pc, code, reg, mem, out)
            {:addi, rd, rs, imm} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                reg = Register.write(reg, rd, s + imm)
                run(pc, code, reg, mem, out)
            {:sub, rd, rs, rt} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                reg = Register.write(reg, rd, s - t)
                run(pc, code, reg, mem, out)
            {:lw, rt, rs, imm} ->
                pc = pc + 4
                s = Register.read(reg, rs)

            {:sw, rt, rs, imm} ->
                pc = pc + 4
                t = Register.read(reg, rs)
                reg = Register.write(reg, rt, t + imm)
            {:beq, rs, rt, offset} ->
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                cond do 
                    s == t ->
                        pc = pc + 4 + offset
                    true -> 
                        pc = pc + 4
                end
            {:label, name} ->
                mem = [{:label, name}, {:word, pc}| mem]
                pc = pc + 4
                run(pc, code, reg, mem, out)
        end
    end
end 

defmodule Program do
    
    def load(prgm) do
        {:prgm, code, data} = prgm
        {code, data}
    end
    
    def read([h|t], adress) do
        {{:label, adr}, {:word, x}} = h
        cond do
            adr == adress ->
                x
            [h|t] == [] -> 0
            true ->
            read(t, adress)
        end
    end

    def write([h|t], adress, value, new) do
        {{:label, adr}, {:word, x}} = h
        cond do
            adr == adress ->
                Register.reverse(new) ++ [{{:label, adr}, {:word, x}}|t]
            [h|t] == [] -> 0
            true ->
            write(t, adress, value, [h|new])
        end
    end

    def read_instruction([h|t], pc) do
        case pc do
        0 -> h
        _ -> read_instruction(t, pc - 4)
        end
    end
end

defmodule Register do

    def new() do
        [
        {0, 0},
        {1, 0},
        {2, 0},
        {3, 0},
        {4, 0},
        {5, 0},
        {6, 0},
        {7, 0},
        {8, 0},
        {9, 0},
        {10, 0},
        {11, 0},
        {12, 0},
        {13, 0},
        {14, 0},
        {15, 0},
        {16, 0},
        {17, 0},
        {18, 0},
        {19, 0},
        {20, 0},
        {21, 0},
        {22, 0},
        {23, 0},
        {24, 0},
        {25, 0},
        {26, 0},
        {27, 0},
        {28, 0},
        {29, 0},
        {30, 0},
        {31, 0},
        ]
    end

    def read([h|t], nbr) do
        {n, value} = h
        cond do
            nbr == n ->
                value
            true ->
                read(t, nbr)
        end
    end

    def write(reg, nbr, value) do
        write(reg, nbr, value, [])
    end
    def write([h|t], nbr, value, new) do
        {n, _} = h
        cond do
            nbr == n ->
                reverse(new) ++ [{nbr, value}|t]
            true -> 
                write(t, nbr, value, [h|new])
        end
    end
    def reverse([]) do
        []
    end
    def reverse([h|t]) do
        reverse(t) ++ [h]
    end

end

defmodule Out do

    def new() do
        []
    end

    def put(list, print) do
        list ++ [print]
    end
    def close([]) do :ok end
    def close([h|t]) do
        IO.puts(h)
        close(t)
    end

end