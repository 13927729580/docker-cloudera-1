## Dockerize Cloudera Proof-of-Concept

Run
```
$ docker-compose up -d 
```
Rebuild
```
$ docker-compose up -d --build 
``` 
Access console 
```
$ docker exec -it cloudera bash
```

### Setup Cluster 
Add localhost node 
- go to http://localhost:7180
- login (admin / admin)
- start wizard
    - Select Edition select _Cloudera Express_
    - Specify Hosts click on _Current Managed Hosts_ tab and select _cloudera_ hostname
    - Select Repository, use _Parcels_ and select _CDH-6.3.1_
    - Select Services, select _Essentials_
    - Setup Database (MySQL)
        - Hive (database=metastore, user=hive, password=hive)
        - Activity Monitor (database=amon, user=amon, password=amon)
        - Oozie Server (database=oozie, user=oozie, password=oozie)
        - Hue (database=hue, user=hue, password=hue)
    - Configurations
        - dfs.datanode.data.dir=/hadoop/hdf/data
        - dfs.namenode.name.dir=/hadoop/hdf/namenode
        - dfs.namenode.checkpoint.dir=/hadoop/hdf/secondaryname
        - yarn.nodemanager.local-dirs=/hadoop/hdf/local
        - dfs.replication=1



