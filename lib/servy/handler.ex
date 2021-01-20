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


defmodule Servy.Handler do

    @moduledoc """
    Handles HTTP requests
    """

    @doc """
    Transforms a request into a response
    """
    def handle(request) do
        request 
        |> parse
        |> Servy.Plugins.rewrite_path 
        |> Servy.Plugins.log
        |> route
        |> Servy.Plugins.track 
        |> format_response
    end

    
    def parse(request) do
    #pattern match the method and path using atoms
    [method, path, _] =
        request 
            |> String.split("\n") 
            |> List.first 
            |> String.split(" ")
        
        %{ method: method, path: path, resp_body: "", status: nil }
    end

    def route(conv) do #takes a conv map already having method and path, from the parse function
        route(conv, conv.method, conv.path) #call a two-arity function, and check for a pattern match
    end

    def route(conv, "GET", "/banks") do #function clause
        %{ conv | status: 200, resp_body: "KCB, Co-op, Equity" }
    end

    #module attributes can also be used as constants
    #using constants also helps with effecting changes at specific parts of the program
    #constants should reside at the top of module because their values are set at compile time

    def route(conv, "GET", "/about") do 
        case File.read("pages/index.html") do
            {:ok, content} -> 
                %{ conv | status: 200, resp_body: content} 
            {:error, :enoent} ->
                %{ conv | status: 404, resp_body: "File is not found"} 
        end
    end

    def route(conv, "GET", "/branches") do #function clause
        %{ conv | status: 200, resp_body: "Kangemi, Muthurua, CBD" }
    end

    def route(conv, "GET", "/branches/" <> id) do
        %{conv | status: 200, resp_body: "#{id} Branch" }
    end

    
    def route(conv, _method, path) do #use variables for a catch-all route. The variables are boud to whatever argument
        #put catch-all route at the bottom of the clauses
        #defualt function clauses come last
        #group function clauses together    
    %{ conv | status: 404, resp_body: "No #{path} here" }
    end

    def format_response(conv) do
        """
        HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
        Content-Type: text/html
        Content-Length: #{String.length(conv.resp_body)}

        #{conv.resp_body}
        """
    end

    defp status_reason(code) do #private function
    #can't be called outside this module 
        %{
            200 => "OK", #keys are numbers, not atoms
            201 => "Created", #match number to code
            401 => "Unauthorized",
            403 => "Forbidden",
            404 => "Not Found",
            500 => "Internal Server Error"
        }[code]#access value tied to the number, code
    end
end


request = """
GET /banks HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /branches HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /branches/Kangemi HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bank HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /benki HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response
