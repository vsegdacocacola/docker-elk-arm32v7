# docker-elk-arm32v7

Based on https://github.com/herpiko/arm32v7-elk-docker

## Notes: 
1. Make sure you set on host RPI
    ```
    sudo sysctl -w vm.max_map_count
    ```

2. Build and launch elasticsearch container
```
cd ./elasticsearch
docker build -t elasticsearch .
docker run --add-host=elasticsearch:172.17.0.1 -d -p 9200:9200 --name elasticsearch --restart=always -d elasticsearch
```

3. Build and launch kibana container
```
cd ./kibana
docker build -t kibana .
docker run --add-host=kibana:172.17.0.2 -d -p 5601:5601 --link=elasticsearch --name kibana --restart=always -d kibana
```
4. Build and launch filebeat container
```
cd ./filebeat
docker build -t filebeat .
docker run -d -p 2000:2000 -p 2514:2514/udp --add-host=filebeat:172.17.0.3 --link=elasticsearch --name filebeat -restart=always -d filebeat

```
5. Build and launch logstash container

TODO:
1. Docker compose
2. Wait for kibana to optimize plugins and revert back NODE_OPTIONS to 512