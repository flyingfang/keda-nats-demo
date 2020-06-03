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

2.helm install nats charts

```shell script
$ helm install my-nats charts/nats
```

// TODO...
