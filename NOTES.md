# Overview

This terraform project manages resilient EC2 instance deployed into
more that one availability zone in custom VPC.
ALB is used to distribute the traffic and HTTP health checks are in use.
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
* Test Nginx access from both regions
```bash
for domain in ireland_domain us_domain; do echo "### $domain ###" && curl $(terraform output $domain); done
```
* You should see default Nginx page printed once for each region.
