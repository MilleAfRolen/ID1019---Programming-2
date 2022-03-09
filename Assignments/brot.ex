defmodule Brot do


    def mandelbrot(c={r, i}, m) do
        test(0, Cmplx.new(0,0), c, m)
    end

    def test(_, _, _, 0) do 0 end
    def test(i, z, c, m) do
        cond do
            Cmplx.abs(z) > 2 ->
                i
            true -> test(i+1, Cmplx.add(Cmplx.sqr(z), c), c, m-1)
        end
    end

end