
defmodule Servy.Handler do

    @moduledoc """
    Handles HTTP requests
    """
    alias Servy.Conv

    import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
    import Servy.Parser, only: [parse: 1]
    @doc """
    Transforms a request into a response
    """
    def handle(request) do
        request 
        |> parse
        |> rewrite_path 
        |> log
        |> route
        |> track 
        |> format_response
    end


    #def route(conv) do #takes a conv map already having method and path, from the parse function
     #   route(conv, conv.method, conv.path) #call a two-arity function, and check for a pattern match
    #end

    def route(%Conv{method: "GET", path: "/banks"} = conv) do #function clause
        %{ conv | status: 200, resp_body: "KCB, Co-op, Equity" }
    end

    #module attributes can also be used as constants
    #using constants also helps with effecting changes at specific parts of the program
    #constants should reside at the top of module because their values are set at compile time

    def route(%Conv{method: "GET", path: "/about"} = conv) do 
        case File.read("pages/index.html") do
            {:ok, content} -> 
                %{ conv | status: 200, resp_body: content} 
            {:error, :enoent} ->
                %{ conv | status: 404, resp_body: "File is not found"} 
        end
    end

    def route(%Conv{method: "GET", path: "/branches"} = conv) do #function clause
        %{ conv | status: 200, resp_body: "Kangemi, Muthurua, CBD" }
    end

    def route(%Conv{method: "GET", path: "/branches/" <> id} = conv) do
        %{conv | status: 200, resp_body: "#{id} Branch" }
    end

    
    def route(%Conv{path: path} = conv) do #use variables for a catch-all route. The variables are boud to whatever argument
        #put catch-all route at the bottom of the clauses
        #defualt function clauses come last
        #group function clauses together    
    %{ conv | status: 404, resp_body: "No #{path} here" }
    end

    def format_response(%Conv {} = conv) do
        """
        HTTP/1.1 #{Conv.full_status(conv)}
        Content-Type: text/html
        Content-Length: #{String.length(conv.resp_body)}

        #{conv.resp_body}
        """
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
