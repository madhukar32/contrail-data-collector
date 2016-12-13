# contrail-data-collector

## Cloning the repository
`$ git clone https://github.com/madhukar32/contrail-data-collector.git`

## Building the container
`$ cd contrail-data-collector `

`$ docker build -t data_collector .`

## Creating the docker container
`$ docker run --name contrail-data-collector -p 80:80 -p 3000:3000 -p 8083:8083 -p 8086:8086 -td data_collector`

## Login to influxdb
`http://localhost:8083/`

## Login to grafana
`http://localhost:3000/`
