# IoTc

IoTc (Internet of Things commander) is a LoRaWAN network server implementation in elixir.

## Setup

    $ git clone https://github.com/tooreht/iotc
    $ cd iotc
    $ mix deps.get
    $ mix ecto.setup
    $ (cd apps/appsrv && npm install)
    $ (cd apps/nwksrv && npm install)
    $ mix phoenix.server
    $ open http://localhost:4000
    $ open http://localhost:8000

## Docker

This section describes how to setup the IoTc development environment with docker. The included `docker-compose.yml` file starts the following docker containers as services in a separate network `iotc_backend`:

| Service      | Description                     |
| -------------| ------------------------------- |
| `iotc`       | LoRaWAN network server          |
| `prometheus` | Monitoring and alerting toolkit |
| `vernemq0`   | VerneMQ MQTT message broker #1  |
| `vernemq1`   | VerneMQ MQTT message broker #2  |
| `vernemq2`   | VerneMQ MQTT message broker #3  |

### Quickstart

**1. Start containers**

Start up the containers in the background (`-d` switch) from the project root:

    $ docker-compose up -d


**2. Setup VerneMQ**

Get the status of the VerneMQ cluster:

    $ docker-compose exec vernemq0 vmq-admin cluster status
    +------------------+-------+
    |       Node       |Running|
    +------------------+-------+
    |VerneMQ@172.18.0.3| true  |
    +------------------+-------+

If there is only one node listed, we need to join the other ones to the cluster:

    $ docker-compose exec vernemq1 vmq-admin cluster join discovery-node=VerneMQ@172.18.0.3
    Done

    $ docker-compose exec vernemq2 vmq-admin cluster join discovery-node=VerneMQ@172.18.0.3
    Done

Check if the nodes are connected to the cluster now:

    $ docker-compose exec vernemq0 vmq-admin cluster status
    +------------------+-------+
    |       Node       |Running|
    +------------------+-------+
    |VerneMQ@172.18.0.3| true  |
    |VerneMQ@172.18.0.4| true  |
    |VerneMQ@172.18.0.5| true  |
    +------------------+-------+

Setup a MQTT user and password:

    $ docker-compose exec vernemq0 vmq-passwd -c /etc/vernemq/vmq.passwd iotc
    Password:
    Reenter password:

**3. Connect MQTT client**

Connect your MQTT client over `tcp://<HOST_IP:1883>` to publish/subscribe to topics.

**4. Access Prometheus**

Access the Prometheus web page over `http://<HOST_IP:9090>`.

**5. Connect to IoTc**

Connect to IoTc via remote console:

    $ docker-compose exec iotc bin/iotc remote_console

**6. Stop containers**

Stop the containers:

    $ docker-compose stop
