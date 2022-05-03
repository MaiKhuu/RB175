require "socket"

server = TCPServer.new("localhost", 3003)
lines = []
loop do
  client = server.accept
  loop do
    lines << client.gets
    puts lines[-1]
    break if lines[-1] == "\r\n"
  end

  lines.each{ |line| client.puts line }
  client.close
end