defmodule Servy.Parser do 
    def parse(request) do
    #pattern match the method and path using atoms
    [method, path, _] =
        request 
            |> String.split("\n") 
            |> List.first 
            |> String.split(" ")
        
        %{ method: method, path: path, resp_body: "", status: nil }
    end

end