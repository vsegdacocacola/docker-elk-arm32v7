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
docker run -d -p 9200:9200 elasticsearch
```

3. Build and launch kibana container
```
cd ./kibana
docker build -t kibana .
docker run -d -p 5601:5601 kibana
```

TODO:
1. Logstash container
2. Docker composer