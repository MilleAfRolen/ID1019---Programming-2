defmodule Mandel do

    def mandelbrot(width, height, x, y, k, depth) do
        trans = fn(w, h) -> 
            Cmplx.new(x+k * (w-1), y-k * (h-1))
        end

        rows(width, height, trans, depth, [])
    end

    def rows(width, height, trans, depth, acc) do
        #fixes the row
        row = row(width, height, trans, depth, [])
        #takes us to next row
        rows(width, height-1, trans, depth, [row | acc])
    end

    def row(width, height, trans, depth, []) do
        pixel = Brot.mandelbrot(trans.(width,height), depth)
        Color.convert(pixel, depth)

    end
end