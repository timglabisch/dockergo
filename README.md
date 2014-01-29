# lamp stack and vagrant replacement based on docker.

## Requirements
1. Install Docker.
2. Install run sudo apt-get install sshpass mysql-client

# Howto
Look at the ./dockergo and change some ports if you want
just run the "./dockergo run", on the first time it takes a few minutes.

just start changing the content in the htdocs directory.
you can see it of you open 127.0.0.1:(http_port), defaults to 80. 

# MySql
it will try to connect the local mysql host.

you can get a mysql console running "./dockergo mysql"

# SSH
just run "./dockergo ssh"

# xdebug
it will try to connect the hosts xdebug listener by default.

# Why i think this is this smarter than Vagrant + Virtualbox + Chef / Puppet
It's blanzing fast.
It performs very well, you can run a lot containers without any problems.
It saves space.
Docker is more like a api, you can do a lot of cool stuff :)

# Why i think this isn't smarter than Vagrant + Virtualbox + Chef / Puppet
Its a bit more complex
Sometimes you get in trouble with software that dont run out of the box in docker
There isnt something like provisioning at the moment, but keep in mind you could use Chef & Puppet in Docker, too.
