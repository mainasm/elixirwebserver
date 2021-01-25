defmodule Servy.Plugins do
 
    alias Servy.Conv

    @doc """
    logs 404 request
    """
    def track(%Conv{status: 404, path: path} = conv) do
        IO.puts "Warning: #{path} is unavailable"
        conv
    end

    def track(%Conv{} = conv), do: conv

    def rewrite_path(%Conv{path: "/bank"} = conv) do
        %{conv | path: "/banks"}
    end
    
    def rewrite_path(%Conv{} = conv), do: conv 

    def log(conv), do: IO.inspect conv
    #split request into multiple lines, and fetch method, path
end
