defmodule Servy.Plugins do
 @doc """
    logs 404 request
    """
    def track(%{status: 404, path: path} = conv) do
        IO.puts "Warning: #{path} is unavailable"
        conv
    end

    def track(conv), do: conv

    def rewrite_path(%{path: "/bank"} = conv) do
        %{conv | path: "/banks"}
    end
    
    def rewrite_path(conv), do: conv 

    def log(conv), do: IO.inspect conv
    #split request into multiple lines, and fetch method, path
end
