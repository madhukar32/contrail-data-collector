# data-collector-container

## Prerequisites
Docker should be installed, Follow this [link](https://docs.docker.com/engine/installation/)

## Cloning the repository
`$ git clone https://github.com/madhukar32/data-collector-container.git`

## Building the container
`$ cd data-collector-container `

`$ docker build -t data_collector .`

## Creating the docker container
`$ docker run --name data_collector -p 80:80 -p 3000:3000 -p 8083:8083 -p 8086:8086 -td data_collector`

## Login to influxdb
`http://localhost:8083/`

## Login to grafana
`http://localhost:3000/`
