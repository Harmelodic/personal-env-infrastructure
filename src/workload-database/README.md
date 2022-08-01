# workload-database

Since I'm cheap and don't want to have a single database instance per microservice, I'm going instead just have one or
two database instances but create SQL databases with the database instances.

Each "workload" that requires a database will get its own database within a database instance.

This is where this module comes in, where you can provide information about the database instance, and information about
the workload, then the module will create the necessary resources and permissions to create a database and configuration
for the workload to connect to the database instance.

## The ConfigMap produced

A Kubernetes [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) is produced as part of this
module that contains all the information needed to create a connection to the database:

| Key                      | Value                                                                                  |
|--------------------------|----------------------------------------------------------------------------------------|
| database                 | Name of the database (this is the same as the name of your workload)                   |
| instance_connection_name | Instance Connection Name for the Database Instance (as provided by the input variable) |
| username                 | Username that the workload should use. In the format: `workload@project-id.iam`        |

The workload can interact with this 

## Outputs

| Output                          | Type   | Description                                                                     |
|---------------------------------|--------|---------------------------------------------------------------------------------|
| connection_config_map_name      | string | Name of the ConfigMap that is created.                                          |
| connection_config_map_namespace | string | Namespace where the ConfigMap is created.                                       |
| sql_username                    | string | Username that the workload should use. In the format: `workload@project-id.iam` |
