require 'socket'

server = TCPServer.open 2000
clients = []
acceptThread = Thread.start do
  loop {
    Thread.start(server.accept) do |client|
      clients << client
      loop {
        m = client.recv 100
        puts m 
      }
    end
  }
end

loop {
  m = gets.chomp
  if m == "shutdown"
    Thread.kill acceptThread
    clients.each do |client|
      client.close
    end
    server.close
    break
  end
}
