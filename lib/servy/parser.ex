defmodule Servy.Parser do 

    alias Servy.Conv

    def parse(request) do
    #pattern match the method and path using atoms
    [method, path, _] =
        request 
            |> String.split("\n") 
            |> List.first 
            |> String.split(" ")
        
        %Conv{ method: method, path: path}
    end

end