# Overview

This terraform project manages resilient EC2 instance deployed into
more that one availability zone in custom VPC across two regions.
ALB is used to distribute the traffic and HTTP health checks are in use.

SSH access to instances is restricted to bastion host private IP only.
This is achieved via Security Groups only. See Improvements section for potentially better approach.

EC2 instance also deploys a Java App via UserData and Nginx proxies HTTP calls to it.

__WARN!!__ : Without modifying any variables you will create the following billable resources :
* 4 x t2.small EC2 instances in eu-west-1
* 1 ALB in eu-west-1
* 7 x t2. small EC2 instances in us-east-1
* 1 ALB in us-east-1

# How to Deploy

* Set AWS API Key and Secret Key
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="eu-west-1"
```
* Set variable values in `global.tfvars` file if required.
* Initialise all the modules
```bash
terraform init
```
* Run
```bash
terraform apply -var-file=global.tfvars
```
* Wait for the instance to be fully built and provisioned
* Test Java App access from both regions
```bash
for domain in ireland_domain us_domain; do echo "### $domain ###" && curl $(terraform output $domain)/java-app/; done
```
* You should see default Nginx page printed once for each region.


# Improvements
* Create private subnets within VPC module with default route to NAT gateway
* Place all (except bastion) instances into private subnets
* Restrict SSH access to instances only from bastion via ACL + SGs
* Disable public IP allocation to all instances (except bastion)
* Ensure ALB can reach EC2s in private subnets
* Improve deployment process
* Set healcheck path to /java-app
