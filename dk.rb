
def CreateMachine(name)
  token_file = File.join(File.dirname(__FILE__), "do.token")
  f = File.open(token_file, "rb")
  token = f.read
  f.close
  token = token.strip!
  system "docker-machine create --driver digitalocean --digitalocean-image ubuntu-14-04-x64 --digitalocean-access-token #{token} #{name}"
  puts 'Machine created'

end

def SaveImageToMachine(machine, image)
  puts `docker save -o tmp.tar #{image}`
  UploadImageToMachine(machine)
  puts 'Machine saved to the remote server'
  puts `docker-machine ssh #{machine} docker load -i tmp.tar`
  system "rm tmp.tar"
  puts 'Machine loaded to the remote docker server'
end

def UploadImageToMachine(machine)
  system "docker-machine scp tmp.tar #{machine}:/root"
end

def RunImageInMachine(machine, image)
  system "docker-machine ssh #{machine} docker run -p 8080:8080 -t #{image}"
  puts "#{image} up and running in #{machine}"
end

def ListRemoteMachines()
  system "docker-machine ls"
end

def RemoveRemoteMachine(machine)
  system "docker-machine rm #{machine}"
end

def PrintHelp()
  puts "Commands available"
  puts "create [name of droplet]                   -- Creates a new droplet"
  puts "save   [name of machine] [name of image]   -- Save a local image to a droplet"
  puts "run [name of machine] [name of image]      -- Runs an image in a droplet"
  puts "remove [name of machine]                   -- Remvoe a remote machine"
  puts "list                                       -- Lists all remote machines"
end

PrintHelp()

prompt = "> "

print prompt

while (input = gets.chomp)

  break if input == "exit"

  if input.include? "create"
    CreateMachine(input.split[1])
  end

  if input.include? "save"
    SaveImageToMachine(input.split[1], input.split[2])
  end

  if input.include? "run"

    RunImageInMachine(input.split[1], input.split[2])
  end

  if input == "list"
    ListRemoteMachines()
  end

  if input.include? "remove"
    RemoveRemoteMachine(input.split[1])
  end

  if input == "help"
    PrintHelp()
    puts " "
  end

  system(input)

  print prompt

end
