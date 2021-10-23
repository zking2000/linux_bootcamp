# Create customize network
docker network create --driver bridge --subnet 192.168.250.0/24 --gateway 192.168.250.1 docker-vmnet8
docker network create --driver bridge --subnet 192.168.1.0/24 --gateway 192.168.1.1 --internal docker-vmnet10
docker network create --driver bridge --subnet 192.168.2.0/24 --gateway 192.168.2.1 --internal docker-vmnet11
docker network create --driver bridge --subnet 192.168.3.0/24 --gateway 192.168.3.1 --internal docker-vmnet12

# Create container
docker run -d -P -v `pwd`/volume-vmnet10:/opt/volume-vmnet10 --name container-vmnet10 --net docker-vmnet10 centos:7 sh -c "sleep 3600"
docker run -d -P -v `pwd`/volume-vmnet11:/opt/volume-vmnet11 --name container-vmnet11 --net docker-vmnet11 centos:7 sh -c "sleep 3600"
docker run -d -P -v `pwd`/volume-vmnet10:/opt/volume-vmnet12 --name container-vmnet12 --net docker-vmnet12 centos:7 sh -c "sleep 3600"
docker run -d -P -v `pwd`/volume-vmnet10:/opt/volume-vmnet13 --name container-vmnet13 --net docker-vmnet12 centos:7 sh -c "sleep 3600"

# attach particular container to an specific network
docker network connect docker-vmnet10 container-vmnet11
docker network connect docker-vmnet11 container-vmnet12

# Allow specific container access to extranet
docker network connect docker-vmnet8 container-vmnet10
docker network connect docker-vmnet8 container-vmnet11
docker network connect docker-vmnet8 container-vmnet12
docker network connect docker-vmnet8 container-vmnet13

# Remove extranet from specific container
docker network disconnect docker-vmnet8 container-vmnet10
docker network disconnect docker-vmnet8 container-vmnet11
docker network disconnect docker-vmnet8 container-vmnet12
docker network disconnect docker-vmnet8 container-vmnet13
