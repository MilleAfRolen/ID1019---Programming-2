defmodule Color do

    def convert(depth, max) do 
        f = depth/max
        a = f*4
        x = trunc(a)
        y = trunc(255*(a-x))

        case x do
            0 ->
                {:rgb, y, 0, 0} #add red
            1 ->
                {:rgb, 255, y, 0} #from red to orange to yellow
            2 ->
                {:rgb, 255-y, 255, 0} #yellow to green
            3 ->
                {:rgb, 0, 255, y} #green -> light blue
            4 ->
                {:rgb, 0, 255-y, 255} #light blue -> blue
        end

    end



end