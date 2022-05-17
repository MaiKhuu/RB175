require "socket"

def parse_request(request_line)
  http_method, path_and_params, http_version = request_line.split(" ")
  path, full_query = path_and_params.split("?")

  params = nil
  if !full_query.nil?
    params = full_query.split("&").each_with_object({}) do |pair, hash|
      k, v = pair.split("=")
      hash[k] = v
    end
  end

  return http_method, path, params, http_version
end

# server = TCPServer.new("localhost", 3003)

# this is how we can get the browser to work in AWS C9
server = TCPServer.new(ENV["IP"], ENV["PORT"])

loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts
  client.puts "<html>"
  client.puts "<body>"

  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Rolls!</h1>"
  unless params.nil?
    rolls = params["rolls"].to_i
    sides = params["sides"].to_i
    rolls.times { client.puts "<p> #{rand(sides) + 1} <\p>" }
  end

  client.puts "</body>"
  client.puts "</html>"
  client.close
end