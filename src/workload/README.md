# workload module

A workload, semantically, is a thing that is going to be running on Kubernetes.

To identify the workload within Kubernetes, we want to associate the workload with a Kubernetes Service Account (that
this module will create).

To allow the workload within Kubernetes to identity & authenticate/authorize with Google Services (or anything else that
accepts Google Service Account Auth), this module also creates a Google Service Account and associates the Google
Service Account with the aforementioned Kubernetes Service Account, using a system that is referred as "Workload
Identity".

## Outputs

| Output                     | Type                       | Description                                                       |
|----------------------------|----------------------------|-------------------------------------------------------------------|
| google_service_account     | google_service_account     | Google Service Account resource object that has been created.     |
| kubernetes_service_account | kubernetes_service_account | Kubernetes Service Account resource object that has been created. |
| name                       | string                     | Name of Workload.                                                 |
| namespace                  | string                     | Namespace of Workload.                                            |
