# Overview

This terraform project manages resilient EC2 instance deployed into
more that one availability zone in custom VPC.
ALB is used to distribute the traffic and HTTP health checks are in use.
# How to Deploy

* Set AWS API Key and Secret Key
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```
* Set variable values in `dublin.tfvars` file if required.
* Run
```bash
terraform apply -var-file=dublin.tfvars
```
* Wait for the instance to be fully built and provisioned
* Test Nginx access
```bash
terraform output web_domain | xargs curl
```
* You should see default Nginx page.
