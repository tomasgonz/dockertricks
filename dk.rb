token_file = File.join(File.dirname(__FILE__), "do.token")

f = File.open(token_file, "rb")

token = f.read

f.close

token = token.strip!

system "docker-machine create --driver digitalocean --digitalocean-image  ubuntu-14 -04-x64 --digitalocean-access-token '" + token + "' tdocker"
