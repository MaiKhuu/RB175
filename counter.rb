require "socket"

server = TCPServer.new(ENV["IP"], ENV["PORT"])

# returns http_method, path, params, http_version
def parse_request(request_line)
  http_method, path_and_params, http_version = request_line.split(" ")

  path, full_query = path_and_params.split("?")

  params = {}
  unless full_query.nil?
    full_query.split("&") do |pair|
        k, v = pair.split("=")
        params[k] = v
    end

  return http_method, path, params, http_version
end


end

loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"

  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p>The current number is: #{number}</p>"

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end