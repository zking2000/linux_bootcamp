# DOCKER

```
OCI: Open Container Initiative

docker version

Docker CLI
|
REST API
|
Docker Daemon (images, Volumes, Networks)
|
Containerd (Manage Containers)
|
Containerd-shim - "responsible for keeping the containers alive when the docker daemon goes down"
|
runC (Run containers)
|
libcontainer - "responsible for managing containers on Linux on version 1.15 of Docker engine"
|
(Namespace CGroups)
```

# Docker Engine Installation
```
```

# DOCKER SERVICE CONFIGURATION
```
/var/run/docker.sock
^
|
DOkcer CLI

dockerd --debug --host=tcp://192.168.1.10:2375 --tls=true --tlscert=xxx --tlskey=xxx

default configuration file: /etc/docker/daemon.json
# example daemon.json: https://gist.github.com/melozo/6de91558242fb8ca4212e4a73fbddde6

docker -H=tcp://<host>:<port> ps -a
```

# DOCKER OPERATIONS
```
docker attach ubuntu

docker kill ubuntu

docker run -it ubuntu - /var/lib/docker/containers/xxx

docker ps

docker ls

docker rename <new name>

docker attach <container name or id>

docker inspect <container name>

docker stats # check consumed resources

docker top <container name> # display the running processes inside the container

docker logs <container name>
docker logs -f <container name>

docker system events --since 60m

# kill -9 $(pgrep  httpd)
# kill -SIGSTOP $(pgrep  httpd) - pause the process,states preserved
# kill -SIGCONT $(pgrep  httpd) - resume paused process
# kill -SIGTERM $(pgrep  httpd) - stop or terminal the process
# kill -SIGKILL $(pgrep  httpd) - terminated process immediately

docker pause <container name>
docker unpause <container name>
docker stop <container name>
docker kill --signal=9 <container name>

docker ls -q # list all container's ID only
docker stop $(docker container ls -q)
docker rm $(docker container ls -q)

docker prune # remove all stopped containers
```

# Setting a Container Hostname
```
docker run -it --name=webapp --hostname=webapp ubuntu
```
# Restart Policies
```
docker run --restart=<LIST> webapp
LIST:
NO
ON-FAILURE
ALWAYS
UNLESS STOPPED
```

# Copying Contents into Container
```
docker cp <source file> <cotnainer name>:<destination path in container>
```

# Publish Ports
```

```

###########################################################################

# Resource Limit CPU
```
Completely Fair Scheduler (CFS)

docker container run --cpuset-cpus=0-1 <image name> # reserve CPU for 0 - 1
docker container run --cpus=2.5 <image name>
docker container update --cpus=0.5 <image name>
```

# Resource Limit memory
```
docker container run --memory=512m <image name>
docker container run --memory=512m --memory-swap=512m <image name>
```

# Docker Networking
```

```