## Microservice Architecture with Azure Spring Cloud

### Looking for [Detailed Approach](https://github.com/whyaneel/azure-spring-cloud-demo/wiki)

### Quickly Load Env Variables
- After you add your Subscription
```
source ./setup_env_variables.sh
```

### Azure Resources Creation
#### - Create Resource Group and Azure Spring Cloud Instance
```
az account set --subscription "$SUBSCRIPTION_ID"

az group create -g "$RESOURCE_GROUP_NAME" -l "$REGION_NAME"

az spring-cloud create -g "$RESOURCE_GROUP_NAME" -n "$SPRING_CLOUD_NAME"
```

#### - Create Config Server in Azure Spring Cloud
Use Azure Web Portal to map Github repo [azsc-config-server](https://github.com/whyaneel/azsc-config-server) to the config server

For Simplicity, I've generated [config-server-import.yml](https://raw.githubusercontent.com/whyaneel/azure-spring-cloud-demo/master/config-server-import.yml) file where we'll mention SpringCloudConfigServerGit-Uri, username, and password (**Github PAT**) and import this in Azure Web Portal under _Spring Cloud > Config Server_

#### - Create Azure Database for Postgres
Follow Steps mentioned in  `./setup_azure_postgres.sh`


### Create Apps (Microservices) in Spring Cloud
```
az spring-cloud app create -n azsc-user-directory-service

az spring-cloud app create -n azsc-search-directory-service

az spring-cloud app create -n azsc-gateway --is-public true
```

### Deploy Apps to Spring Cloud
- Compiled Jars are added
```
az spring-cloud app deploy -n azsc-user-directory-service --jar-path ./azsc-user-directory-service/build/libs/azsc-user-directory-service-0.0.1-SNAPSHOT.jar

az spring-cloud app deploy -n azsc-search-directory-service --jar-path ./azsc-search-directory-service/target/azsc-search-directory-service-0.0.1-SNAPSHOT.jar

az spring-cloud app deploy -n azsc-gateway --jar-path ./azsc-gateway/target/azsc-gateway-0.0.1-SNAPSHOT.jar
```

### Access User Directory Management APP
https://azsc-from-paloit-azsc-gateway.azuremicroservices.io/index.html

Following APIs will route to respective Microservices as per [Routing](https://github.com/whyaneel/azsc-config-server/blob/master/azsc-gateway.yml)
* https://azsc-from-paloit-azsc-gateway.azuremicroservices.io/api/admin/users
* https://azsc-from-paloit-azsc-gateway.azuremicroservices.io/api/search/users

<video src="azsc-demo.mp4" poster="azsc-poster.png" width="320"
height="200" controls preload></video>

### Cleanup Resources
- This is to save cost, once you're done with demo
```
az group delete --name $RESOURCE_GROUP_NAME --yes
```

