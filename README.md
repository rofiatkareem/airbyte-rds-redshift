# E-commerce Data Pipeline

This project provisions AWS infrastructure with **Terraform** and deploys **Airbyte on Minikube** to replicate data from **Amazon RDS PostgreSQL** into **Amazon Redshift** for analytics. The goal is to simulate a production-style pipeline where transactional data in RDS is continuously moved into Redshift for reporting and analysis.

## Architecture
![Architecture Diagram](docs/architecture_diagram.png)

- **Amazon RDS PostgreSQL** – Operational database (source)
- **Airbyte on Minikube** – Replication service (incremental sync)
- **Amazon Redshift** – Analytics warehouse (destination)
- **Terraform** – Infrastructure as Code (VPC, subnets, security groups, IAM, RDS, Redshift)

Flow:  
`RDS → Airbyte (Minikube) → Redshift`

## Resource Provisioning with Terraform
All AWS resources are defined under `infrastructure/`.

To deploy:
```bash
cd ingestion/infrastructure
terraform init
terraform plan
terraform apply
```

## Resources Provisioned
- **VPC** for network isolation  
- **Public and private subnets**  
- **Subnet groups** for RDS and Redshift  
- **Security groups** with least-privilege rules  
- **IAM roles and policies** for Airbyte and Redshift  
- **Amazon RDS PostgreSQL instance**  
- **Amazon Redshift cluster**  

## Running Airbyte on Minikube
Airbyte is deployed locally on **Minikube** for portability and reproducibility.

### Start Minikube 
```bash
minikube start
kubectl create namespace airbyte
```
### Install Airbyte via Helm
```bash
helm repo add airbyte https://airbytehq.github.io/helm-charts
helm repo update
helm upgrade --install airbyte airbyte/airbyte -n airbyte
```
### Access the UI
```bash
kubectl -n airbyte port-forward svc/airbyte-webapp-svc 8000:80
```
Then open [http://localhost:8000](http://localhost:8000).

## Configuring the RDS → Redshift Connection
1. Create a **Postgres source** in Airbyte using the RDS endpoint, user, and password.  
2. Create a **Redshift destination** using the cluster endpoint and credentials.  
3. Select **Incremental Sync with Deduped History** as the replication strategy.  
4. Run the connection to replicate data from RDS into Redshift.