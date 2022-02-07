defmodule Emulator do


    def test() do
        code =  [
            {:addi, 1, 0, 5}, {:lw, 2, 0, :arg}, {:add, 4, 2, 1}, {:addi, 5, 0, 1}, {:label, :loop},
            {:sub, 4, 4, 5}, {:out, 4}, {:bne, 4, 0, :loop}, :halt
        ]
        data = [{{:label, :arg}, {:word, 12}}]
        run({:prgm, code, data})
    end

    def test2() do
        code =  [
            {:addi, 1, 0, 5}, {:sw, 1, 0, :hello}, {:lw, 2, 0, :hello}, {:add, 2, 1, 2}, {:sw, 2, 0, :hello}, {:out, 2}, :halt
        ]
        data = []
        run({:prgm, code, data})
    end

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
                value = Program.read(mem, imm)
                reg = Register.write(reg, rt, value)
                run(pc, code, reg, mem, out)
            {:sw, rt, rs, adr} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                value = Register.read(reg, rt)
                mem = Program.write(mem, adr, value, [])
                run(pc, code, reg, mem, out)
            {:beq, rs, rt, adress} ->
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                cond do 
                    s == t ->
                        pc = Program.read(mem, adress)
                        run(pc, code, reg, mem, out)
                    true -> 
                        pc = pc + 4
                        run(pc, code, reg, mem, out)
                end
            {:bne, rs, rt, adress} ->
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                cond do 
                    s != t ->
                        pc = Program.read(mem, adress)
                        run(pc, code, reg, mem, out)
                    true -> 
                        pc = pc + 4
                        run(pc, code, reg, mem, out)
                end 
            {:label, name} ->
               mem = [{{:label, name}, {:word, pc}}| mem]
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
    
    def write([], adress, value, new) do
        Enum.reverse(new) ++ [{{:label, adress}, {:word, value}}]
    end
    def write([h|t], adress, value, new) do
        {{:label, adr}, {:word, _}} = h
        cond do
            adr == adress ->
                Enum.reverse(new) ++ [{{:label, adr}, {:word, value}}|t]
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
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        ]
    end

    def read(reg, regNbr) do
        Enum.at(reg, regNbr)
    end
    def write(reg, regNbr, value) do
        List.replace_at(reg, regNbr, value)
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