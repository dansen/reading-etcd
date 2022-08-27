
# create network
docker network create --driver bridge --subnet=10.2.36.0/16 --gateway=10.2.1.1 mynet2
docker network ls

# node 1
docker run -d \
-p 2479:2379 \
-p 2381:2380 \
--name node1 --rm \
--network=mynet2 \
--ip 10.2.36.1 \
quay.io/coreos/etcd:latest \
etcd \
-name node1 \
-advertise-client-urls http://10.2.36.1:2379 \
-initial-advertise-peer-urls http://10.2.36.1:2380 \
-listen-client-urls http://0.0.0.0:2379 -listen-peer-urls http://0.0.0.0:2380 \
-initial-cluster-token etcd-cluster \
-initial-cluster "node1=http://10.2.36.1:2380,node2=http://10.2.36.2:2380,node3=http://10.2.36.3:2380" \
-initial-cluster-state new

# node 2
docker run -d \
-p 2579:2379 \
-p 2382:2380 \
--name node2 --rm \
--network=mynet2 \
--ip 10.2.36.2 \
quay.io/coreos/etcd:latest \
etcd \
-name node2 \
-advertise-client-urls http://10.2.36.2:2379 \
-initial-advertise-peer-urls http://10.2.36.2:2380 \
-listen-client-urls http://0.0.0.0:2379 -listen-peer-urls http://0.0.0.0:2380 \
-initial-cluster-token etcd-cluster \
-initial-cluster "node1=http://10.2.36.1:2380,node2=http://10.2.36.2:2380,node3=http://10.2.36.3:2380" \
-initial-cluster-state new

# node 3
docker run -d \
-p 2679:2379 \
-p 2383:2380 \
--name node3 --rm \
--network=mynet2 \
--ip 10.2.36.3 \
quay.io/coreos/etcd:latest \
etcd \
-name node3 \
-advertise-client-urls http://10.2.36.3:2379 \
-initial-advertise-peer-urls http://10.2.36.3:2380 \
-listen-client-urls http://0.0.0.0:2379 -listen-peer-urls http://0.0.0.0:2380 \
-initial-cluster-token etcd-cluster \
-initial-cluster "node1=http://10.2.36.1:2380,node2=http://10.2.36.2:2380,node3=http://10.2.36.3:2380" \
-initial-cluster-state new

# check id
docker ps

# check cluster list
docker exec -it [container-id] etcdctl member list

docker exec -it [container-id] etcdctl set message hi

docker exec -it [container-id] etcdctl get message

