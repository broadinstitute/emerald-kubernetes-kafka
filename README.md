# Kafka for Kubernetes

This community seeks to provide:
 * Production-worthy Kafka setup for persistent (domain- and ops-) data at small scale.
 * Operational knowledge, biased towards resilience over throughput, as Kubernetes manifest.
 * A platform for event-driven (streaming!) microservices design using Kubernetes.

To quote [@arthurk](https://github.com/Yolean/kubernetes-kafka/issues/82#issuecomment-337532548):

> thanks for creating and maintaining this Kubernetes files, they're up-to-date (unlike the kubernetes contrib files, don't require helm and work great!

## Getting started

We suggest you `apply -f` manifests in the following order:
```
 #storage configuration for gcp
 kubectl apply -f ./configure

 #create namespace in k8s
 kubectl apply -f 00-namespace.yml

 #add your account as cluster admin
 kubectl create clusterrolebinding <username>-cluster-admin-binding --clusterrole cluster-admin --user <username>@broadinstitute.org                                

 #configure podsecuritypolicies
 kubectl --namespace=dev apply -f ./configure/psp

 #deploy zookeeper
 kubectl apply --namespace=dev -f ./zookeeper

 #deploy kafka
 kubectl apply --namespace=dev -f ./kafka

 #expose kafka outside pods
 kubectl apply --namespace=dev -f ./outside-services
 ```


That'll give you client "bootstrap" `bootstrap.kafka.svc.cluster.local:9092`.

## Fork

Our only dependency is `kubectl`. Not because we dislike Helm or Operators, but because we think plain manifests make it easier to collaborate.
If you begin to rely on this kafka setup we recommend you fork, for example to edit [broker config](https://github.com/Yolean/kubernetes-kafka/blob/master/kafka/10broker-config.yml#L47).

## Version history

| tag   | k8s ≥  | highlights |
| ----- | ------ | ---------- |
| v5.0.3 | 1.11+ | Zookeeper fix [#227](https://github.com/Yolean/kubernetes-kafka/pull/227) + [maxClientCnxns=1](https://github.com/Yolean/kubernetes-kafka/pull/230#issuecomment-445953857) |
| v5.0  | 1.11+  | Destabilize because in Docker we want Java 11 [#197](https://github.com/Yolean/kubernetes-kafka/pull/197) [#191](https://github.com/Yolean/kubernetes-kafka/pull/191) |
| v4.3.1 | 1.9+  | Critical Zookeeper persistence fix [#228](https://github.com/Yolean/kubernetes-kafka/pull/228) |
| v4.3  | 1.9+   | Adds a proper shutdown hook [#207](https://github.com/Yolean/kubernetes-kafka/pull/207) |
| v4.2  | 1.9+   | Kafka 1.0.2 and tools upgrade |
|       |        | ... see [releases](https://github.com/Yolean/kubernetes-kafka/releases) for full history ... |
| v1.0  | 1      | Stateful? In Kubernetes? In 2016? Yes. |

## Outside (out-of-cluster) access

Available for:

 * [Brokers](./outside-services/)
