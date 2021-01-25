defmodule Servy.Conv do
    defstruct [method: "", path: "", resp_body: "", status: nil]

def full_status (conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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
 