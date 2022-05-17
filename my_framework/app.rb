require_relative "monroe"
require_relative "advice"

class App < Monroe
  def call(env)
    case env["REQUEST_PATH"]
    when "/"
      # this code works but is not clean
      # ["200",
      # {"Content-Type" => "text/html"},
      # [erb(:index)]]

      # this code is better
      status = "200"
      headers = {"Content-Type" => "text/html"}
      response(status, headers) do
        erb(:index)
      end
    when "/advice"
      piece_of_advice = Advice.new.generate

      # ["200",
      # {"Content-Type" => "text/html"},
      # [erb(:advice, message: piece_of_advice)]]

      status = "200"
      headers = {"Content-Type" => "text/html"}
      response(status, headers) do
        erb(:advice, message: piece_of_advice)
      end
    else
      # ["404",
      # {"Content-Type" => "text/html"},
      # [erb(:notfound)]]

      status = "404"
      headers = {"Content-Type" => "text/html"}
      response(status, headers) do
        erb(:notfound)
      end
    end
  end


end