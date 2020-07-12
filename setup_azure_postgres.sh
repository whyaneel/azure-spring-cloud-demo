# Create Postgres Server (Basic, Gen 5, Core 1)
az postgres server create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AZ_POSTGRES_SERVER \
    --location $REGION_NAME \
    --sku-name B_Gen5_1 \
    --storage-size 5120 \
    --admin-user $AZ_POSTGRESQL_ADMIN_USER \
    --admin-password $AZ_POSTGRESQL_ADMIN_PASSWORD \
    | jq

# (Optional) Create Firewall Rule to connect from Local Machine
az postgres server firewall-rule create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AZ_POSTGRES_SERVER-database-allow-local-ip \
    --server $AZ_POSTGRES_SERVER \
    --start-ip-address $AZ_LOCAL_IP_ADDRESS \
    --end-ip-address $AZ_LOCAL_IP_ADDRESS \
    | jq

# Create A Database in Postgres Server
az postgres db create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AZ_DATABASE_NAME \
    --server-name $AZ_POSTGRES_SERVER \
    | jq

# Disable SSL and Allow Apps to Access Postgres from Azure Web Portal


# (Optional) Create a Azure Postgres Read Replica
az postgres server replica create --name $AZ_POSTGRES_REPLICA_SERVER --source-server $AZ_POSTGRES_SERVER --resource-group $RESOURCE_GROUP_NAME

az postgres server replica list --server-name $AZ_POSTGRES_SERVER --resource-group $RESOURCE_GROUP_NAME