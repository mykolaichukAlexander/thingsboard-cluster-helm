# Thingsboard helm chart

ThingsBoard is an open-source IoT platform that enables rapid development, management, and scaling of IoT projects.

[More details about Thingsboard](https://thingsboard.io/)


## Prerequisites
- Kubernetes 1.12+
- Helm 3+
- PV provisioner support in the underlying infrastructure
- License Key - if you plan to use Thingsboard PE

## Introduction
### Get Your ThingsBoard Up and Running on Kubernetes

This guide helps you set up ThingsBoard, an open-source platform for managing Internet of Things (IoT) devices, on a Kubernetes cluster. We'll use Helm, a popular package manager for Kubernetes, to streamline the process.

### What is ThingsBoard?

ThingsBoard lets you quickly develop, manage, and scale your IoT projects. It's a great choice if you're working with connected devices and want an easy way to get started.

### Deployment Options

There are two main ways to deploy ThingsBoard on Kubernetes:

   - **Monolith**: This is a simpler setup where all the components of ThingsBoard run together with a PostgreSQL database. It's a good option for smaller projects or getting started.
   - **Microservices**: This more complex setup breaks ThingsBoard down into smaller, independent services. This makes it easier to scale different parts of the system as needed and handle large amounts of data.
Microservices require additional software like Kafka for queuing messages, Zookeeper for coordinating services, and Redis for caching data.

> **_NOTE:_**  Thingsboard by itself supports various services for queue , cache, but this chart for now supports only services noticed above.

### Choosing a Database

ThingsBoard can use either PostgreSQL or a combination of PostgreSQL and Cassandra. Cassandra is a good option if you expect to manage a massive amount of data.

### Want to Learn More?

For detailed instructions on setting up ThingsBoard in either configuration, refer to the official documentation:

[Community Edition (CE)](https://thingsboard.io/docs/)
[Professional Edition (PE)](https://thingsboard.io/docs/pe/)


## Using Third Party Services with ThingsBoard
This Helm chart for ThingsBoard lets you integrate with several third-party services, including Kafka, Cassandra, Redis, and Zookeeper. You have two options for these services:

### 1 Internal Deployments (Managed by this Chart)

This option allows you to easily deploy these services alongside ThingsBoard using official Bitnami charts as sub-charts. These charts are pre-configured for quick setup. Here are the available services:

[Redis](https://artifacthub.io/packages/helm/bitnami/redis)
[Redis Cluster](https://artifacthub.io/packages/helm/bitnami/redis)
[Cassandra](https://github.com/bitnami/charts/blob/main/bitnami/cassandra/README.md)
[PostgreSQL](https://artifacthub.io/packages/search?repo=bitnami)
[Kafka](https://artifacthub.io/packages/helm/bitnami/kafka)
[Zookeeper](https://artifacthub.io/packages/helm/bitnami/zookeeper)

You can customize these internal deployments using prefixes in your configuration file. Here's a table summarizing the prefixes:

| Service Name	     |       Prefix        |
|-------------------|:-------------------:|
| Redis	            |    internalRedis    |
| Kafka	            |    internalKafka    |
| Cassandra	        |  internalCassandra  |
| Zookeeper	        |  internalZookeeper  |
| PostgreSQL	       | internalPostgresql  |

By default, all internal deployments are enabled. Here's an example of how to configure storage size for the internal Kafka deployment:

```yaml
internalKafka:
  persistence:
    size: 35Gi
```
### 2 External Deployments (Pre-Existing Services)

This option is for situations where you already have these services deployed and configured elsewhere. You can still use this chart to connect ThingsBoard to your existing services. All external service configurations take priority over internal ones. Here's a table showing the prefixes for external services:

| Service Name	     |       Prefix        |
|-------------------|:-------------------:|
| Redis	            |    externalRedis    |
| Kafka	            |    externalKafka    |
| Cassandra	        |  externalCassandra  |
| Zookeeper	        |  externalZookeeper  |
| PostgreSQL	       | externalPostgresql  |

For more details about configuration options, please refer to the "Parameters" section of the documentation.


> [!WARNING]  
> If you're going to use internal third party services please don`t use them in production mode before configuring them.
> For configuration you can use [Official bitnami docs](https://bitnami.com/)


## Installing the Chart

Here's how to install the ThingsBoard cluster chart:

Add the Repository:
```shell
helm repo add thingsboard-cluster-betta https://mykolaichukalexander.github.io/thingsboard-cluster-chart/
```
This command adds the thingsboard-cluster-betta repository to your Helm repositories.

Install the Chart:
```shell
helm install my-thingsboard-cluster thingsboard-cluster-betta/thingsboard-cluster --version 0.1.0
```
This command installs the ThingsBoard cluster using the `thingsboard-cluster` chart from the `thingsboard-cluster-betta repository`.
It gives the release the name `my-thingsboard-cluster` and sets the version to `0.1.0`.

This command installs the ThingsBoard cluster with the following specifications:

  - Release name: my-thingsboard-cluster
  - Chart version: 0.1.0
  - Default configuration:
    - Microservices (MSA) architecture;
    - Community Edition (CE) - 1 Tb-Core and 1 Tb-Rule-Engine;
    - Messaging and caching services: Kafka;
    - Cache: Redis;
    - Service Coordination: Zookeeper;
    - Database: PostgreSQL.


## Uninstalling ThingsBoard

To uninstall the ThingsBoard cluster, use the following command:
```shell
helm delete my-thingsboard-cluster -n namespace
```

This command removes all the ThingsBoard components associated with the chart (release named `my-thingsboard-cluster`) from the specified namespace (namespace).

Important Note:

The helm delete command removes the logical resources of the ThingsBoard cluster. To completely remove all persistent data, you may need to additionally delete the Persistent Volume Claims (PVCs) after uninstallation.
```shell
kubectl delete pvc -l release=my-thingsboard-cluster
```

This command deletes all PVCs with the label release=my-thingsboard-cluster.

## Parameters

## Installation Parameters

| Name                    |                                                                                                                                                                                                                 Description                                                                                                                                                                                                                 |                         Value |
|-------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|------------------------------:|
| installation.msa        |                                                                                              Thingsboard architecture Type. Thingsboard can run in two different configurations. To decide in what configuration you should run your cluster please visit https://thingsboard.io/docs/pe/reference/#monolithic-vs-microservices-architecture.                                                                                               |                          true |
| installation.installTb  | This field is responsible for the installation process of Thingsboard. The installation process will create all needed databases tables (in PostgreSQL in case of only "Postgres Mode" for Timeseries. Or in PostgreSQL and Cassandra in the case of "hybrid mode". For more information on how to choose the most suitable option for you please visit https://thingsboard.io/docs/pe/reference/#sql-vs-nosql-vs-hybrid-database-approach. |                         false |
| installation.loadDemo   |                                                                                                                                                                Works only with installation.installTb: true. This option will load into database some prepared data for you.                                                                                                                                                                |                         false |
| installation.pe         |                                                                                                                                                  Switch on Professional Edition mode. For more information please visit https://thingsboard.io/docs/getting-started-guides/helloworld-pe/.                                                                                                                                                  |                         false |
| installation.licenseKey |                                                                                                                If you plan to use the Professional Edition version of Thingsboard you need to provide this key. You can get this key from Thingsboard team. In the case of Community Edition, you can skip this field empty.                                                                                                                |                            "" |
| dockerAuth.registry     |                                                                                                                                                                                                   Docker registry for Thingsboard images                                                                                                                                                                                                    | "https://index.docker.io/v1/" |
| dockerAuth.username     |                                                                                                                                                                                            Docker username on which pull secret will be created                                                                                                                                                                                             |                            "" |
| dockerAuth.password     |                                                                                                                                                                                          Docker user password on which pull secret will be created                                                                                                                                                                                          |                            "" |



## Global Parameters

| Name                   |            Description             |   Value |
|------------------------|:----------------------------------:|--------:|
| global.imagePullSecret | Global Docker registry secret name | regcred |


## Thingsboard Node Parameters

This node category will use to configure Thingsboard node in monolith mode or core in MSA mode.

| Name                                   |                                                                                                                                  Description                                                                                                                                   |                     Value |
|----------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|--------------------------:|
| node.image.repository                  |                                                                                              Repository option that has the highest priority and will override global.repository                                                                                               |       thingsboard/tb-node |
| node.image.tag                         |                                                                                                     Tag option that has the highest priority and will override global.tag                                                                                                      | Chart Application Version |
| node.imagePullPolicy                   |                                                                                                                        Node/core pull policy for image                                                                                                                         |                    Always |
| node.statefulSet.replicas              |                                                                                                                     Replica count for node(core) services                                                                                                                      |                         1 |
| node.ports                             |                                                                 List of ports for node(core) service, you can just add your custom ports as list entries and their will be rendered and added to node manifest                                                                 |                           |
| node.nodeSelector                      | Node selector for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. Usually it is Map type. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details |                        {} |
| node.affinity                          |               Affinity for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details                |                        {} |
| node.customEnv                         |                                                  A Map for custom environment variable for node(core) service. If not empty, all env vars will be added on config map and will path to pods. Useful while custom developing.                                                   |                        {} |
| node.readinessProbe.httpGet.path       |                                                                                                                       Node/core path for readiness probe                                                                                                                       |                    /login |
| node.readinessProbe.httpGet.port       |                                                                                                                       Node/core port for readiness probe                                                                                                                       |                      8080 |
| node.livenessProbe.httpGet.path        |                                                                                                                       Node/core path for liveness probe                                                                                                                        |                    /login |
| node.livenessProbe.httpGet.port        |                                                                                                                       Node/core port for liveness probe                                                                                                                        |                      8080 |
| node.livenessProbe.initialDelaySeconds |                                                                                                                        Node/core initial delay seconds                                                                                                                         |                       460 |
| node.livenessProbe.timeoutSeconds      |                                                                                                                           Node/core timeout seconds                                                                                                                            |                        10 |
| node.restartPolicy                     |                                                                                                                          Node/core pod restart policy                                                                                                                          |                    Always |
| node.securityContext.runAsUser         |                                                                                                                             Node/core run as user                                                                                                                              |                       799 |
| node.securityContext.runAsNonRoot      |                                                                                                                           Node/core run as non root                                                                                                                            |                      true |
| node.securityContext.fsGroup           |                                                                                                                               Node/core fs group                                                                                                                               |                       799 |
| node.persistence.enabled               |                          Persistence layer for node pods. In case of Professional Edition it is required for managing license. Or if you plan to use custom extensions with saving some state that need to "survive" pod lifetime events ot updates.                           |                      true |
| node.persistence.existingClaim         |                                                                                                                            Node/core existing claim                                                                                                                            |                        "" |
| node.persistence.size                  |                                                                                                                   Node/core pvc size that will be requested                                                                                                                    |                       1Gi |
| node.persistence.accessModes           |                                                                                                                             Node/core access modes                                                                                                                             |       [ "ReadWriteOnce" ] |
| node.persistence.storageClass          |                                                                                                                          Node/core storage class name                                                                                                                          |                           |
| node.resources.limits.cpu              |                                                                                                                                   Limit cpu                                                                                                                                    |                   "2000m" |
| node.resources.limits.memory           |                                                                                                                                  Limit memory                                                                                                                                  |                    3000Mi |
| node.resources.requests.cpu            |                                                                                                                                  Requests cpu                                                                                                                                  |                   "1000m" |
| node.resources.requests.memory         |                                                                                                                                Requests memory                                                                                                                                 |                    2000Mi |

Node/core means that in case of monolith this parameters will configure node pod that contains Core/Rule engine functionality,
in case of msa - just core .

Default ports `node.ports` are: 
```yaml
  ports:
    - name: http
      value: 8080
    - name: edge
      value: 7070
    - name: grpc
      value: 9090
```

## Thingsboard Rule Engine Parameters

| Name                                     |                                                                                                                                 Description                                                                                                                                  |                     Value |
|------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|--------------------------:|
| engine.image.repository                  |                                                                                            RE Repository option that has the highest priority and will override global.repository                                                                                            |       thingsboard/tb-node |
| engine.image.tag                         |                                                                                                   RE Tag option that has the highest priority and will override global.tag                                                                                                   | Chart Application Version |
| engine.imagePullPolicy                   |                                                                                                                           RE pull policy for image                                                                                                                           |                    Always |
| engine.statefulSet.replicas              |                                                                                                                    Replica count for rule engine services                                                                                                                    |                         1 |
| engine.ports                             |                                                            List of ports for rule engine service, you can just add your custom ports as list entries and their will be rendered and added to rule engine manifest                                                            |                           |
| engine.nodeSelector                      | RE selector for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. Usually it is Map type. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details |                        {} |
| engine.affinity                          |             RE Affinity for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details             |                        {} |
| engine.customEnv                         |                                                 A Map for custom environment variable for node(core) service. If not empty, all env vars will be added on config map and will path to pods. Useful while custom developing.                                                  |                        {} |
| engine.readinessProbe.httpGet.path       |                                                                                                                         RE path for readiness probe                                                                                                                          |                    /login |
| engine.readinessProbe.httpGet.port       |                                                                                                                         RE port for readiness probe                                                                                                                          |                      8080 |
| engine.livenessProbe.httpGet.path        |                                                                                                                          RE path for liveness probe                                                                                                                          |                    /login |
| engine.livenessProbe.httpGet.port        |                                                                                                                          RE port for liveness probe                                                                                                                          |                      8080 |
| engine.livenessProbe.initialDelaySeconds |                                                                                                                           RE initial delay seconds                                                                                                                           |                       460 |
| engine.livenessProbe.timeoutSeconds      |                                                                                                                              RE timeout seconds                                                                                                                              |                        10 |
| engine.restartPolicy                     |                                                                                                                            RE pod restart policy                                                                                                                             |                    Always |
| engine.securityContext.runAsUser         |                                                                                                                               RE  run as user                                                                                                                                |                       799 |
| engine.securityContext.runAsNonRoot      |                                                                                                                              RE run as non root                                                                                                                              |                      true |
| engine.securityContext.fsGroup           |                                                                                                                                 RE fs group                                                                                                                                  |                       799 |
| engine.persistence.enabled               |                         Persistence layer for node pods. In case of Professional Edition it is required for managing license. Or if you plan to use custom extensions with saving some state that need to "survive" pod lifetime events ot updates.                          |                      true |
| engine.persistence.existingClaim         |                                                                                                                              RE existing claim                                                                                                                               |                        "" |
| engine.persistence.size                  |                                                                                                                                 RE affinity                                                                                                                                  |                       1Gi |
| engine.persistence.accessModes           |                                                                                                                               RE access modes                                                                                                                                |       [ "ReadWriteOnce" ] |
| engine.persistence.storageClass          |                                                                                                                            RE storage class name                                                                                                                             |                           |
| engine.resources.limits.cpu              |                                                                                                                                  Limit cpu                                                                                                                                   |                   "2000m" |
| engine.resources.limits.memory           |                                                                                                                                 Limit memory                                                                                                                                 |                    3000Mi |
| engine.resources.requests.cpu            |                                                                                                                                 Requests cpu                                                                                                                                 |                   "1000m" |
| engine.resources.requests.memory         |                                                                                                                               Requests memory                                                                                                                                |                    2000Mi |

## Thingsboard Web Report(WR) Parameters

Thingsboard Web Report Service configuration section

| Name                             |                                                                                                                                 Description                                                                                                                                  |                     Value |
|----------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|--------------------------:|
| report.enabled                   |                                                                                                               Enable of disable web report service in cluster.                                                                                                               |                      true |
| report.image.repository          |                                                                                       Repository that will be used for web report service. If blank - default repository will be used.                                                                                       |                           |
| report.image.tag                 |                                                                                              Tag that will be used for web report service. If blank - default tag will be used.                                                                                              | Chart Application Version |
| report.deployment.replicas       |                                                                                                                     WR Default replica count for service                                                                                                                     |                         1 |
| report.nodeSelector              | WR selector for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. Usually it is Map type. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details |                        {} |
| report.affinity                  |             WR Affinity for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details             |                        {} |
| report.resources.limits.cpu      |                                                                                                                                  Limit cpu                                                                                                                                   |                   "2000m" |
| report.resources.limits.memory   |                                                                                                                                 Limit memory                                                                                                                                 |                    3000Mi |
| report.resources.requests.cpu    |                                                                                                                                 Requests cpu                                                                                                                                 |                   "1000m" |
| report.resources.requests.memory |                                                                                                                               Requests memory                                                                                                                                |                    2000Mi |


## Thingsboard Web UI Parameters (for msa installation type)

Thingsboard Web UI Service configuration section

| Name                          |                                                                                                                                   Description                                                                                                                                    |                     Value |
|-------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|--------------------------:|
| web.enabled                   |                                                                                                                 Enable of disable web report service in cluster.                                                                                                                 |                      true |
| web.image.repository          |                                                                                           Repository that will be used for web ui service. If blank - default repository will be used                                                                                            |                           |
| web.image.tag                 |                                                                                                  Tag that will be used for web ui service. If blank - default tag will be used                                                                                                   | Chart Application Version |
| web.deployment.replicas       |                                                                                                                      Web UI replicas that will be deployed                                                                                                                       |                         1 |
| web.nodeSelector              | Web UI selector for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. Usually it is Map type. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details |                        {} |
| web.affinity                  |             Web UI Affinity for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details             |                        {} |
| web.resources.limits.cpu      |                                                                                                                                 Web UI limit cpu                                                                                                                                 |                    "100m" |
| web.resources.limits.memory   |                                                                                                                               Web UI limit memory                                                                                                                                |                     100Mi |
| web.resources.requests.cpu    |                                                                                                                               Web UI requests cpu                                                                                                                                |                    "100m" |
| web.resources.requests.memory |                                                                                                                              Web UI requests memory                                                                                                                              |                     100Mi |


## Thingsboard JS Executor Parameters

Thingsboard JavaScript Executor Service configuration section
JavaScripts executor executes all js scripts on Rule Engine and Integrations etc.
Now Thingsboard has alternative such as TBEL (https://thingsboard.io/docs/user-guide/tbel/).
But if you plan use JavaScript js.enabled should be true

| Name                         |                                                                                                                                      Description                                                                                                                                      |  Value |
|------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|-------:|
| js.enabled                   |                                                                                                                   Enable of disable js-executor service in cluster.                                                                                                                   |  false |
| js.image.repository          |                                                                                           Repository that will be used for js-executor service. If blank - default repository will be used                                                                                            |        |
| js.image.tag                 |                                                                                                  Tag that will be used for js-executor service. If blank - default tag will be used                                                                                                   |        |
| js.deployment.replicas       |                                                                                                                      Js Executor replicas that will be deployed                                                                                                                       |      5 |
| js.nodeSelector              | Js Executor selector for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. Usually it is Map type. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details |     {} |
| js.affinity                  |             Js Executor Affinity for choosing nodes for scheduling pods. Note that this is default kubernetes object, so you need to specify whole object, not just labels. See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ for more details             |     {} |
| js.resources.limits.cpu      |                                                                                                                                 Js Executor limit cpu                                                                                                                                 | "100m" |
| js.resources.limits.memory   |                                                                                                                               Js Executor limit memory                                                                                                                                |  100Mi |
| js.resources.requests.cpu    |                                                                                                                               Js Executor requests cpu                                                                                                                                | "100m" |
| js.resources.requests.memory |                                                                                                                              Js Executor requests memory                                                                                                                              |  100Mi |


## Thingsboard Transports Parameters (for msa installation type)

Transport configuration. (more on https://thingsboard.io/docs/reference/msa/)
Thingsboard has various options for different protocols that can help you connect devices with
Thingsboard platform. In this configuration transports it is a Map like structure. Example:
```yaml
transports:
  http: {transport config object}
  mqtt: {transport config object}
```

Keys for transports can be `http`, `coap`, `lwm2m`, `snmp`, `mqtt`

As `transport config object` you can customise next parameters: 

| Name                      |                                                                                 Description                                                                                 |                                         Value |
|---------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|----------------------------------------------:|
| enabled                   |                                                             Enable or disable this transport into your cluster                                                              |                                         false |
| name                      |                                      Name that will be used for kubernetes resources like sts and services for TRANSPORT_KEY transport                                      | http-transport `(example for http transport)` |
| image.repository          |                                                  Transport custom repository. When blank - default repository will be used                                                  |                                               |
| image.tag                 |                                                     Transport custom tag. When blank - default repository will be used                                                      |                     Chart Application Version |
| replicas                  |                                                                             Transport replicas                                                                              |                                             1 |
| ports                     | Transport ports that container will use. Be sure that this port will match with HTTP_BIND_PORT in env variables. Ports yaml value is similar to Node/Core/Rule engine ports |                                               |
| env                       |                                 Environment variables for http transport service. Charts already has a list of preconfigured env variables                                  |                                               |
| nodeSelector              |                                                                           Transport node selector                                                                           |                                            {} |
| affinity                  |                                                                             Transport affinity                                                                              |                                            {} |
| resources.limits.cpu      |                                                                             Transport limit cpu                                                                             |                                       "1000m" |
| resources.limits.memory   |                                                                           Transport limit memory                                                                            |                                        2000Mi |
| resources.requests.cpu    |                                                                           Transport requests cpu                                                                            |                                        "500m" |
| resources.requests.memory |                                                                          Transport requests memory                                                                          |                                         500Mi |


## Third party Parameters 

### Redis (Cahce)

When you already deploy redis by yourself or using some sort of service this section should be filled.
By external means that redis will be managed  by not this chart.
This type of redis will be configured with prefix `externalRedis`

#### Already existed redis

| Name                   |                                                                                                   Description                                                                                                   | Value |
|------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|------:|
| externalRedis.enable   | If this option is true, chart will know that it should expect external redis. external options are the highest in priority and other redis options like internalRedis and internalRedisCluster will be ignored. | false |
| externalRedis.hosts    |                                                                                 Hosts list for external redis. Format hust:port                                                                                 |    "" |
| externalRedis.cluster  |                                                                        Let to know to Thingsboard that redis is running in cluster mode                                                                         | false |
| externalRedis.password |                                                                                     Password for external redis if expected                                                                                     |    "" |

#### Managed By chart bitnami/redis
Option if you want to use internal redis that will be up and run by this chart. This section will bring
bitnami/redis (https://artifacthub.io/packages/helm/bitnami/redis) into this chart. If you want to add some extra
configuration, you just can put it with key internalRedis, and they will be passed to bitnami/redis chart

| Name                              |                                         Description                                         |          Value |
|-----------------------------------|:-------------------------------------------------------------------------------------------:|---------------:|
| internalRedis.enabled             |                      Enable or disable bitnami/redis into your cluster                      |           true |
| internalRedis.nameOverride        |                           Default name override for bitnami/redis                           |        "redis" |
| internalRedis.architecture        |        Architecture for bitnami/redis. Allowed values: `standalone` or `replication`        |     standalone |
| internalRedis.auth.enabled        |                                         Redis auth                                          |           true |
| internalRedis.auth.password       |                                       Redis password                                        | "testPassword" |


#### Managed By chart bitnami/redis cluster
Option if you want to use internal redis cluster that will be up and run by this chart. This section will bring
bitnami/redis-cluster (https://artifacthub.io/packages/helm/bitnami/redis-cluster) into this chart. If you want to add some extra
configuration, you just can put it with key internalRedisCluster, and they will be passed to bitnami/redis-cluster chart

| Name                              |                        Description                        |          Value |
|-----------------------------------|:---------------------------------------------------------:|---------------:|
| internalRedisCluster.enabled      | Enable or disable bitnami/redis-cluster into your cluster |          false |
| internalRedisCluster.nameOverride |      Default name override for bitnami/redis-cluster      |        "redis" |
| internalRedisCluster.usePassword  |       Enable or disable bitnami/redis-cluster auth        |           true |
| internalRedisCluster.password     |                  Default redis password                   | "testPassword" |

For `internalRedis` prefix, from table above parameters are example of simplest configuration. You can add any parameters 
with this prefix from [Bitnami Redis Doc`s](https://artifacthub.io/packages/helm/bitnami/redis).

For `internalRedisCluster` -  [Bitnami Redis Cluster Doc`s](https://artifacthub.io/packages/helm/bitnami/redis-cluster).

### Zookeeper

#### Already existed zookeeper

When you already deploy Zookeeper by yourself or using some sort of service this section should be filled.
By external means that zookeeper will be managed by not this chart.
If msa mode on, `externalZookeeper.enabled` = true or internalZookeeper.enabled = true  is required

| Name                           |                                                                                          Description                                                                                           |       Value |
|--------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|------------:|
| externalZookeeper.enable       | If this option is true, chart will know that it should expect external kafka. external options are the highest in priority and other zookeeper options like internalZookeeper will be ignored. |       false |
| externalZookeeper.host         |                                                                                    External zookeeper host                                                                                     |             |
| externalZookeeper.port         |                                                                                    External zookeeper port                                                                                     |             |


#### Managed By chart bitnami/zookeeper

Option if you want to use internal Zookeeper that will be up and run by this chart. This section will bring
bitnami/zookeeper (https://artifacthub.io/packages/helm/bitnami/zookeeper) into this chart. If you want to add some extra
configuration, you just can put it with key internalZookeeper, and they will be passed to bitnami/zookeeper chart

| Name                           |                                                                                                    Description                                                                                                     |       Value |
|--------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|------------:|
| internalZookeeper.enable       | If enabled this option bitnami/zookeeper will be deployed. Please note that externalZookeeper.enabled: true will override this option and chart will expect that you already have configured and running zookeeper |        true |
| internalZookeeper.nameOverride |                                                                                              Internal Zookeeper name                                                                                               | "zookeeper" |

For `internalZookeeper` prefix, from table above parameters are example of simplest configuration. You can add any parameters
with this prefix from [Bitnami Zookeeper Doc`s](https://artifacthub.io/packages/helm/bitnami/zookeeper).


### Kafka

#### Already existed Kafka

When you already deploy kafka by yourself or using some sort of service this section should be filled.
By external means that kafka will be managed by not this chart.

| Name                                |                                                                                      Description                                                                                       |               Value |
|-------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|--------------------:|
| externalKafka.enable                | If this option is true, chart will know that it should expect external kafka. external options are the highest in priority and other kafka options like internalKafka will be ignored. |               false |
| externalKafka.hosts                 |                                                                                  External Kafka host                                                                                   |        "kafka:9092" |


#### Managed By chart bitnami/kafka

Option if you want to use internal Kafka that will be up and run by this chart. This section will bring
bitnami/kafka (https://artifacthub.io/packages/helm/bitnami/kafka) into this chart. If you want to add some extra
configuration, you just can put it with key internalKafka, and they will be passed to bitnami/kafka chart

| Name                       |                                                                                              Description                                                                                               |   Value |
|----------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|--------:|
| internalKafka.enable       | If enabled this option bitnami/kafka will be deployed. Please note that externalKafka.enabled: true will override this option and chart will expect that you already have configured and running kafka |    true |
| internalKafka.nameOverride |                                                                                Default name override for bitnami/kafka                                                                                 | "kafka" |
| internalKafka.replicaCount |                                                                                Default replica count for bitnami/kafka                                                                                 |       1 |

For `internalKafka` prefix, from table above parameters are example of simplest configuration. You can add any parameters
with this prefix from [Bitnami Kafka Doc`s](https://artifacthub.io/packages/helm/bitnami/kafka).

### Postgresql


#### Already existed PostgreSql

When you already deploy postgresql by yourself or using some sort of service this section should be filled.
By external means that postgresql will be managed by not this chart.

| Name                             |           Description            |         Value |
|----------------------------------|:--------------------------------:|--------------:|
| externalPostgresql.host          |     External Postgresql host     |            "" |
| externalPostgresql.username      |     External Postgresql user     |        "root" |
| externalPostgresql.password      |   External Postgresql password   |        "root" |
| externalPostgresql.database      |   External Postgresql database   | "thingsboard" |


#### Managed by chart bitnami/postgresql

Option if you want to use internal Postgresql that will be up and run by this chart. This section will bring
bitnami/postgresql (https://artifacthub.io/packages/helm/bitnami/postgresql) into this chart. If you want to add some extra
configuration, you just can put it with key internalPostgresql, and they will be passed to bitnami/postgresql chart

| Name                             |                                                                                                          Description                                                                                                          |        Value |
|----------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|-------------:|
| internalPostgresql.enabled       | If enabled this option bitnami/postgresql will be deployed. Please note that `internalPostgresql.enabled`: true option means that you will not use externalPostgresql and want to deploy bitnami/postgresql within this chart |         true |
| internalPostgresql.nameOverride  |                                                                                         Default name override for bitnami/postgresql                                                                                          | "postgresql" |
| internalPostgresql.architecture  |                                                                        Architecture for bitnami/postgresql. Allowed values: standalone or replication                                                                         |   standalone |
| internalPostgresql.auth.username |                                                                                                    Postgresql server user                                                                                                     |     username |
| internalPostgresql.auth.password |                                                                                                Postgresql server user password                                                                                                |   standalone |
| internalPostgresql.auth.database |                                                                                              Postgresql database for Thingsboard                                                                                              |   standalone |


For `internalPostgresql` prefix, from table above parameters are example of simplest configuration. You can add any parameters
with this prefix from [Bitnami Postgresql Doc`s](https://artifacthub.io/packages/helm/bitnami/postgresql).

### Cassandra

#### Already existed Cassandra

When you already deploy Cassandra by yourself or using some sort of service this section should be filled.
By external means that cassandra will be managed by not this chart
Thingsboard keyspace should be created before install.
If `externalCassandra.enabled` = false and `internalCassandra.enabled` = false that Thingsboard will be configured to work
only with Postgresql

| Name                                  |                                                                                            Description                                                                                             |            Value |
|---------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|-----------------:|
| externalCassandra.enabled             | If this option is true, chart will know that it should expect external cassandra. external options are the highest in priority and other cassandra options like internalCassandra will be ignored. |            false |
| externalCassandra.hosts               |                                                                                      External cassandra host                                                                                       |      "cassandra" |
| externalCassandra.hosts               |                                                                                      External cassandra port                                                                                       |           "9042" |
| externalCassandra.user                |                                                                                      External Cassandra user                                                                                       |      "cassandra" |
| externalCassandra.password            |                                                                                  External Cassandra user password                                                                                  |      "cassandra" |
| externalCassandra.datacenter          |                                                                                   External Cassandra datacenter                                                                                    |            "dc1" |


#### Managed by chart bitnami/postgresql

Option if you want to use internal Cassandra that will be up and run by this chart. This section will bring
bitnami/cassandra (https://artifacthub.io/packages/helm/bitnami/cassandra) into this chart. If you want to add some extra
configuration, you just can put it with key internalCassandra, and they will be passed to bitnami/cassandra chart
If externalCassandra.enabled = false and internalCassandra.enabled = false that Thingsboard will be configured to work
only with Postgresql

| Name                                  |                                                                                                    Description                                                                                                     |          Value |
|---------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|---------------:|
| internalCassandra.enabled             | If enabled this option bitnami/zookeeper will be deployed. Please note that externalCassandra.enabled: true will override this option and chart will expect that you already have configured and running cassandra |          false |
| internalCassandra.replicationStrategy |                                                                           Default Replication Strategy for Keyspace that will be created                                                                           | SimpleStrategy |
| internalCassandra.replicaCount        |                                                                                             Default Replication count                                                                                              |              1 |
| internalCassandra.cluster.datacenter  |                                                                                             Cassandra datacenter name                                                                                              |  "datacenter1" |
| internalCassandra.nameOverride        |                                                                                              Internal Cassandra name                                                                                               |    "cassandra" |
| internalCassandra.initDBConfigMap     |                                                                                         Internal Cassandra init config map                                                                                         | cassandra-init |
| internalCassandra.dbUser.user         |                                                                                              Internal Cassandra user                                                                                               |      cassandra |
| internalCassandra.dbUser.password     |                                                                                            Internal Cassandra password                                                                                             |      cassandra |

For `internalCassandra` prefix, from table above parameters are example of simplest configuration. You can add any parameters
with this prefix from [Bitnami Cassandra Doc`s](https://artifacthub.io/packages/helm/bitnami/cassandra).



For cassandra chart we will use [bitnami/cassandra](https://artifacthub.io/packages/helm/bitnami/cassandra)

If you customise and use internal cassandra we recommend to create a new node group or node pools for your cassandra deployments, you can find information how to do this
by following links:
- [AKS](https://thingsboard.io/docs/user-guide/install/pe/cluster/azure-microservices-setup/#52-cassandra);
- [EKS](https://thingsboard.io/docs/user-guide/install/pe/cluster/aws-microservices-setup/#step-42-cassandra);
- [GKE](https://thingsboard.io/docs/user-guide/install/pe/cluster/gcp-microservices-setup/#step-52-cassandra-optional).
And use `nodeSelector` of affinities for using new created pools.

`cassandra-init` configmap it is pretty simple config that will be used for creating cassandra keyspace and has the following structure
```yaml
...
data:
  "01-init.cql": |
    CREATE KEYSPACE IF NOT EXISTS thingsboard
      WITH REPLICATION = {
        'class': 'SimpleStrategy',
        'replication_factor' : 1
      };
```
Before using cassandra in **production** please create init script that suitable for your infrastructure . 




## Kubernetes Service Providers
This section guides you through deploying a Thingsboard cluster using a Helm chart and configuring it for specific service providers.
We'll cover the essential steps and considerations for tailoring Thingsboard to your chosen service provider.


### AWS (EKS)

#### 1 Create Cluster (Skippable if Existing)

*If you already have a Kubernetes cluster available, you can jump to the next section on installing the Thingsboard chart.*

**Choose Your Approach**:

  - Official AWS Documentation: For a detailed guide, refer to the official AWS documentation on getting started with Amazon EKS using [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html).
    If you decide using this approach pleas be sure that cluster(node group) will have permissions to create volumes and load balancers (if you plan to expose services).
  - Pre-configured Approach: We also offer a pre-configured script or template (see below) to simplify cluster creation on AWS using [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html).

**Install and Configure eksctl (Prerequisite)**:

Before creating a cluster using eksctl, ensure you have eksctl installed and configured on your system.
Follow the eksctl installation instructions [here](https://docs.aws.amazon.com/eks/latest/userguide/setting-up.html).

**Cluster File**

In this example we will use prepared cluster.yaml file to create cluster that 
ThingsBoard team already prepared and you can use with it eksctl:
```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

# Specify desired availability zones. Don't forget to update the 'metadata.region' parameter to match availability zones.
availabilityZones: [us-east-1a,us-east-1b,us-east-1c]

metadata:
  name: super-msa-helm-testing
  # Specify the desired aws region. Don't forget to update the 'availabilityZones' parameter to match the region.
  region: us-east-1
  version: "1.27"

iam:
  withOIDC: true

addons:
  - name: aws-ebs-csi-driver

managedNodeGroups:
  - name: tb-node
    instanceType: m5.xlarge
    desiredCapacity: 3
    maxSize: 3
    minSize: 3
    labels: { role: tb-node }
    # EC2 nodes will be launched in the private subnet and will not be accessible via SSH from the internet.
    privateNetworking: true
    # this option gain additional policies that allow you create load balancers for ingress and transports
    iam:
      withAddonPolicies:
        awsLoadBalancerController: true
  # Uncomment this section if you plan to install and use Cassandra
#  - name: cassandra-1a
#    instanceType: m5.xlarge
#    desiredCapacity: 1
#    maxSize: 1
#    minSize: 1
#    labels: { role: cassandra }
#    availabilityZones: ["us-east-1a"]
#    privateNetworking: true
#    iam:
#      withAddonPolicies:
#        awsLoadBalancerController: true
#  - name: cassandra-1b
#    instanceType: m5.xlarge
#    desiredCapacity: 1
#    maxSize: 1
#    minSize: 1
#    labels: { role: cassandra }
#    availabilityZones: ["us-east-1b"]
#    privateNetworking: true
#    iam:
#      withAddonPolicies:
#        awsLoadBalancerController: true
#  - name: cassandra-1c
#    instanceType: m5.xlarge
#    desiredCapacity: 1
#    maxSize: 1
#    minSize: 1
#    labels: { role: cassandra }
#    iam:
#      withAddonPolicies:
#        awsLoadBalancerController: true
#    availabilityZones: ["us-east-1c"]
```

Where:
- **region** - should be the AWS region where you want your cluster to be located (the default value is us-east-1)
- **availabilityZones** - should specify the exact IDs of the region’s availability zones (the default value is [us-east-1a,us-east-1b,us-east-1c])
- **instanceType** - the type of the instance with TB node (the default value is m5.xlarge)

When you modify this file with all needed for you configs, you can create cluster
```shell
eksctl create cluster -f cluster.yml
```

This cluster.yaml file has couple important options: 

  - ```yaml
    iam:
    withOIDC: true
    ```
    Enables IAM Roles for Service Accounts (IRSA) by default.
    This allows your pods within the cluster to assume IAM roles for interacting with AWS services, 
    in this case cluster will work with Load balancers and Volumes services 

  - ```yaml
    managedNodeGroups:
      iam:
        withAddonPolicies:
          awsLoadBalancerController: true
    ```
    Ensure the managed node groups in your EKS cluster have the necessary permissions to run the AWS Load Balancer Controller add-on.
    This add-on then streamlines managing Application Load Balancers for your Kubernetes services.
    
  - ```yaml
    addons:
      name: aws-ebs-csi-driver
    ```
    Cluster will be created already with attached addon for persistent volume provisioner as aws-ebs-csi-driver


#### 2 aws-load-balancer-controller chart

**Integrating the AWS Load Balancer Controller**

This Thingsboard chart incorporates a sub chart called aws-load-balancer-controller from the official AWS EKS charts [repository](https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/README.md). This sub chart plays a crucial role in managing your load balancing needs.

**What it Does**:

The aws-load-balancer-controller automatically provisions and configures AWS Application Load Balancers (ALBs) for your Thingsboard services.
This eliminates the need for manual configuration and streamlines how you expose your services to the outside world.

**Default Settings**:

The Thingsboard chart comes with pre-configured settings for the aws-load-balancer-controller sub chart.
To change configuration for this sub chart you can use `awscontroller.*` prefix.
Before installing this sub chart we need to fill some of configuration like:
  - clusterName - cluster name that was created in previous step;
  - serviceAccount.create - if service account has already created than we just can leave this as `false`, if we want to chart to create new service account - this option should be `treu`;
  - serviceAccount.name - service account name that will be created or that will be used for creation ALB;


| Name                                |                                                     Description                                                      |       Default Value |
|-------------------------------------|:--------------------------------------------------------------------------------------------------------------------:|--------------------:|
| awscontroller.enabled               |                                            Enable EKS ingress controller                                             |               false |
| awscontroller.clusterName           |                                          Eks cluster name that was created                                           |                     |
| awscontroller.serviceAccount.create |   If added withAddonPolicies then can be true, cause cluster will have permission to create right service account    |               false |
| awscontroller.serviceAccount.name   | Name of created (or what will be created) service account that will be Created automatically from role that provided |                  "" |
| awscontroller.cert.enabled          |                                                     Enable HTTPS                                                     |               false |
| awscontroller.cert.arn              |                               ARN of created certificate from  **Certificate Manager**                               |                     |
| awscontroller.cert.hosts            |                                                    List of hosts                                                     | ["www.example.com"] |

**In essence:**

This integration simplifies how you expose your Thingsboard services publicly using AWS Load Balancers. The sub chart handles the heavy lifting, allowing you to focus on your application logic.
To get more information please visit [doc`s](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)

In next step we will show ho to configure and use it on practice.

#### 3 Preparing values for chart

Before install the chart lets create an eks-values.yaml file that will be responsible for state of our cluster: 

There are a list of custom values file examples:
- Monolith Thingsboard CE with RDS database (Postgresql only):
```yaml
installation:
  msa: false
  pe: false

#This is monolith example install so Kafka, Redis and Zookeeper should be disabled, but because they enabled by default
# in this case we should explicitly disable them
internalKafka:
  enabled: false
internalRedis:
  enabled: false
internalZookeeper:
  enabled: false

# Internal postgres is enabled by default, so we need to explicitly disable it, so we can use external RDS database.
internalPostgresql:
  enabled: false

# This rds Instance was created before. Make sure your nodes in cluster can access
# RDS instance , you need to create new inbound rule from cluster security group to security group of Postgres RDS (https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html fpr more details)
# And auth.database in this case should be created before start
externalPostgresql:
  # Postgresql server host
  host: "YOUR_RDS_HOST"
  # Postgresql server port
  port: 5432
  # Postgresql server user
  username: "postgres"
  # Postgresql server user password
  password: "qwerty123"
  # Postgresql for Thingsboard
  database: "thingsboard1"

awscontroller:
  enabled: true
  clusterName: "msa-helm-testing"
  serviceAccount:
    create: true
    name: tb-cluster-load-balancer-controller
```

- MSA Thingsboard CE with RDS database (Postgresql only):
```yaml
installation:
  msa: true
  pe: false

# Internal postgres is enabled by default, so we need to explicitly disable it, so we can use external RDS database.
internalPostgresql:
  enabled: false

# This rds Instance was created before. Make sure your nodes in cluster can access
# RDS instance , you need to create new inbound rule from cluster security group to security group of Postgres RDS (https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html fpr more details)
# And auth.database in this case should be created before start
externalPostgresql:
  # Postgresql server host
  host: "YOUR_RDS_HOST"
  # Postgresql server port
  port: 5432
  # Postgresql server user
  username: "postgres"
  # Postgresql server user password
  password: "qwerty123"
  # Postgresql database for Thingsboard
  database: "thingsboard"

# In this example we're going to have 2 instances of tb-core and tb-rule-engine services  
node:
  statefulSet:
    replicas: 2

engine:
  statefulSet:
    replicas: 2

awscontroller:
  enabled: true
  clusterName: "super-msa-helm-testing"
  serviceAccount:
    create: true
    name: tb-cluster-load-balancer-controller
```


- MSA Thingsboard CE with RDS database (Postgresql and Cassandra):
```yaml
installation:
  msa: true
  pe: false

internalKafka:
  replicaCount: 3

internalPostgresql:
  enabled: false

# This rds Instance was created before. Make sure your nodes in cluster can access
# RDS instance , you need to create new inbound rule from cluster security group to security group of Postgres RDS (https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html fpr more details)
# And auth.database in this case should be created before start
externalPostgresql:
  # Postgresql server host
  host: "YOUR_RDS_HOST"
  # Postgresql server port
  port: 5432
  # Postgresql server user
  username: "YOUR_RDS_USERNAME"
  # Postgresql server user password
  password: "YOUR_RDS_PASSWORD"
  # Postgresql database for Thingsboard (should be created before)
  database: "thingsboard"


internalCassandra:
  enabled: true
  replicaCount: 3
  nodeSelector: # set cassandra cluster on specially created node group
    role: cassandra

awscontroller:
  enabled: true
  clusterName: "super-msa-helm-testing"
  serviceAccount:
    create: true
    name: tb-cluster-load-balancer-controller
```


In all examples above we have same configuration for awscontroller: 
```yaml
awscontroller:
  enabled: true
  clusterName: "super-msa-helm-testing"
  serviceAccount:
    create: true
    name: tb-cluster-load-balancer-controller
#   For using HTTPS Connection we need to create certificate(AWS Certificate Manager) and put arn and host in this configs 
#  cert:
#    enabled: true
#    arn: arn:aws:acm:your_arn
#    hosts:
#      - your_host
```
This we set `serviceAccount.create: true` and set `name: tb-cluster-load-balancer-controller` so awscontroller chart will create service account before and use it
for provisioning AWS ALB Load balancer.


#### 4 Installing (Finally:))

To install Thingsboard cluster you need to execute following command:
```shell
helm install my-thingsboard-cluster thingsboard-cluster-betta/thingsboard-cluster -f eks-values.yml --set installation.installTb=true --set installation.loadDemo=true
```
where:
- `my-thingsboard-cluster` - your chart release name;
- `eks-values.yml` - custom values file;
- `--set installation.installTb=true` - if you running thingsboard first time this command will said to chart to install database tables;
- `--set installation.loadDemo=true` - if you want to load demo data.

The first-time installation might take a while as the chart creates the database tables and populates them with initial data. Be patient during this process.

Verifying Deployment:

Once the installation is complete, you can check the following:

Application Load Balancer (ALB): AWS should automatically provision an ALB for your Thingsboard cluster. You can retrieve its address using the following command:
```shell
kubectl get ingress
```

Cluster Status: To view the status of your deployed Thingsboard cluster pods, run:
```shell
kubectl get pod
```
This information helps you confirm that your Thingsboard cluster is up and running on your EKS environment.


### Google Kubernetes Engine (GKE)

This chart has basic configuration for using Google Kubernetes Engine Controller that described in [docs](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress-xlb).

Before install if you want to Cluster has the same ip even after ingress recreated you need to follow [this doc](https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address)
and after put a name into `gcloud.loadBalancer.staticAddressName`.

If you pass `gcloud.loadBalancer.cert.enabled` as true chart will create Google manage certificate. Your domain name should resolve to google load balancer ip otherwise certificate will not be approved.


| Name                                           |                                   Description                                    |               Default Value |
|------------------------------------------------|:--------------------------------------------------------------------------------:|----------------------------:|
| gcloud.loadBalancer.enabled                    |                    Enable Google Kubernetes Engine Controller                    |                       false |
| gcloud.loadBalancer.staticAddressName          | Static Address Name  For using same ip for ingress LB(need to be created before) | thingsboard-http-lb-address |
| gcloud.loadBalancer.cert.enabled               |                          Enable certificate for ingress                          |             secret password |
| gcloud.loadBalancer.cert.hosts                 |                       List hosts that will use in ingress                        |          ["www.exaple.com"] |


- ### Azure Kubernetes Service (AKS)

For AKS if you have all needed permissions , after filling all parameters, Kubernetes cluster should create all needed resources.

| Name                            |                Description                 |      Default Value |
|---------------------------------|:------------------------------------------:|-------------------:|
| azure.loadBalancer.enabled      |      Enable AKS Ingress Load Balancer      |              false |
| azure.loadBalancer.cert.enabled |   Enable AKS Ingress Load Balancer HTTPS   |              false |
| azure.loadBalancer.cert.secret  | Secret name that contains your certificate |          akssecret |
| hosts.loadBalancer.cert.hosts   |    List hosts that will use in ingress     | ["www.exaple.com"] |


> **_NOTE:_** For creation secret from cert and key file you can use: 
>```shell
>kubectl create secret tls my-tls-secret \
>  --cert=path/to/cert/file \
>  --key=path/to/key/file
>```



- ### Alibaba Container Service for Kubernetes  (ACK)

For ACK if you have all needed permissions , you just need to enable ALB Add-on before installing or updating chart.
To do so, please [see](https://www.alibabacloud.com/help/en/ack/serverless-kubernetes/user-guide/manage-the-alb-ingress-controller).
After add on enabled, ACK create all needed configs by itself. You just need to `alibabaalbcontroller.enabled` to true and 
this chart will apply needed for Thingsboard routes.


| Name                         |               Description               | Default Value |
|------------------------------|:---------------------------------------:|--------------:|
| alibabaalbcontroller.enabled | Enable ACK Ingress Load Balancer routes |         false |




------

Also chart has a default ingress option that can be applied for test purposes and will expect that service provider has implemented realization.
```yaml
defaultIngress:
  enabled: false
```

