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
SSH access
```
$ ssh root@localhost -p 2204
```
password: _root_

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
        - Hive (_database=metastore, user=hive, password=hive_)
        - Activity Monitor (_database=amon, user=amon, password=amon_)
        - Oozie Server (_database=oozie, user=oozie, password=oozie_)
        - Hue (_database=hue, user=hue, password=hue_)
    - Configurations
        - _dfs.datanode.data.dir_=/hadoop/hdf/data
        - _dfs.namenode.name.dir_=/hadoop/hdf/namenode
        - _dfs.namenode.checkpoint.dir_=/hadoop/hdf/secondaryname
        - _yarn.nodemanager.local-dirs_=/hadoop/yarn/local
        - _dfs.replication_=1



