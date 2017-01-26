# IoTc Documentation

IoTc (Internet of Things commander) is a LoRaWAN server implementation in elixir.

## LoRaWAN

LoRaWAN™ is a Low Power Wide Area Network (LPWAN) specification intended for wireless battery operated Things in a regional, national or global network. LoRaWAN targets key requirements of Internet of Things such as secure bi-directional communication, mobility and localization services. The LoRaWAN specification provides seamless interoperability among smart Things without the need of complex local installations and gives back the freedom to the user, developer, businesses enabling the roll out of Internet of Things.

LoRaWAN network architecture is typically laid out in a star-of-stars topology in which **gateways** is a transparent bridge relaying messages between **end-devices** and a central **network server** in the backend. Gateways are connected to the network server via standard IP connections while end-devices use single-hop wireless communication to one or many gateways. All end-point communication is generally bi-directional, but also supports operation such as multicast enabling software upgrade over the air or other mass distribution messages to reduce the on air communication time.

Communication between end-devices and gateways is spread out on different **frequency channels** and **data rates**. The selection of the data rate is a trade-off between communication range and message duration. Due to the spread spectrum technology, communications with different data rates do not interfere with each other and create a set of "virtual" channels increasing the capacity of the gateway. LoRaWAN data rates range from 0.3 kbps to 50 kbps. To maximize both battery life of the end-devices and overall network capacity, the LoRaWAN network server is managing the data rate and RF output for each end-device individually by means of an **adaptive data rate** (ADR) scheme.

National wide networks targeting internet of things such as critical infrastructure, confidential personal data or critical functions for the society has a special need for secure communication. This has been solved by several layer of encryption:

- Unique Network key (EUI64) and ensure security on network level
- Unique Application key (EUI64) ensure end to end security on application level
- Device specific key (EUI128)

LoRaWAN has several different classes of end-point devices to address the different needs reflected in the wide range of applications:

- **Bi-directional end-devices (Class A)**: End-devices of Class A allow for bi-directional communications whereby each end-device's uplink transmission is followed by two short downlink receive windows. The transmission slot scheduled by the end-device is based on its own communication needs with a small variation based on a random time basis (ALOHA-type of protocol). This Class A operation is the lowest power end-device system for applications that only require downlink communication from the server shortly after the end-device has sent an uplink transmission. Downlink communications from the server at any other time will have to wait until the next scheduled uplink.
- **Bi-directional end-devices with scheduled receive slots (Class B)**: In addition to the Class A random receive windows, Class B devices open extra receive windows at scheduled times. In order for the End-device to open its receive window at the scheduled time it receives a time synchronized Beacon from the gateway. This allows the server to know when the end-device is listening.
- **Bi-directional end-devices with maximal receive slots (Class C)**: End-devices of Class C have nearly continuously open receive windows, only closed when transmitting.

## Apps

This section describes the different apps which the the LoRaWAN server consists of. First all applications at a glance:

| App         | Description                                       |
| ------------| ------------------------------------------------- |
| `appsrv`    | Application server                                |
| `nwksrv`    | Network server                                    |
| `lorawan`   | LoRaWAN protocol implementation                   |
| `semtech`   | Adapter for the semtech packet forwarder protocol |
| `kv`        | Key-Value Store                                   |

This setup is bassed on the following system design:

![IoTc System Design](assets/system-design.png "IoTc System Design")

### NwkSrv

Implements the network component of the LoRaWAN Network Server. Abstracts away most of the LoRaWAN protocol without the decryption and encryption part. So it is responsible for the communication to the nodes over gateways, implements the MAC layer of the LoRaWAN protocol and routes the still encrypted payload to the application component(s).

### AppSrv

Implements the application component of the LoRaWAN Network Server. It is mainly responsible for the decryption and encryption of LoRaWAN packets and distribution of data to the applications.

### LoRaWAN

A LoRaWAN protocol library according to the [specification](https://www.lora-alliance.org/portals/0/specs/LoRaWAN Specification 1R0.pdf). Implements packet structures of all packet types, encoding, decoding, crypto functions, etc. It is used by both, the network server and the application server component.


### Semtech

This module implements the Semtech basic communication protocol between LoraWAN gateway and server as described [here](https://github.com/Lora-net/packet_forwarder/blob/master/PROTOCOL.TXT).

### KV

Simple in memory Key-Value store.

