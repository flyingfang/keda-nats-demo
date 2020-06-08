# Keda nats demo
A sample for keda based on nats streaming.
## Notes
cds-plugin: Baidu cds plugin for pv and pvc 

charts/nats: simple NATS Streaming server chart on baidu-cce

nats-pub: nats publisher demo

nats-sub: nats subscriber demo

## Installation

1.install cds plugin

```shell script
$ kubectl apply -f cds-plugin/
```

2.install keda components
duplicate from keda GitHub: [keda](https://github.com/kedacore/keda)

```shell script
$ kubectl apply -Rf ./keda
```

3.helm install nats charts

```shell script
$ helm install my-nats charts/nats
```

4.helm install my publisher application

```shell script
$ helm install nats-pub charts/pub
```

5.helm install my subscriber application

```shell script
$ helm install nats-sub charts/sub
```

6.install keda nats scaler adapter

```shell script
$ kubectl apply -f keda-nats-scaler/
```
