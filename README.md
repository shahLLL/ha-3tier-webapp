# HA-3TIER-WEBAPP
This repository contains Terraform infrastructure code for a highly available 3 tier web application, deployed on AWS.
# Overview
<div align="center">
  <img src="images/HA-3tier-Webapp.png" alt="System Architecture" width="75%"/>
  <br><br>
</div>
This infrastructure code deploys the 3 tiers typically seen in modern production web applications:

  - **Client Tier** (Frontend)
  - **Server Tier** (Backend)
  - **Database Tier** (Database)

## Overarching
All three tiers are deployed on AWS.

They all preside witin an AWS Region, US West 2 has been arbitrarily chosen and can be easily changed.

Furthermore each tier has multiple availability zones. By default 2 has been assigned for dev/development environments and 3 for prod/production environments. This however can be changed.

All three tiers are deployed/contained within a VPC or Virtual Private Cloud, with an IGW or Internet Gateway Attached to it.


## Client Tier
The client tier contains the following:
  - **A Public Subnet**
  - **A Load Balancer**
  - **A Security Group**
  - **An EC2 Autoscaling Group - with Amazon Linux 2 EC2 Image**
  - **A NAT Gateway**

The EC2 Image can be changed/adapted as needed.

## Server Tier
The server tier contains the following:
  - **A Private Subnet**
  - **A Load Balancer**
  - **A Security Group**
  - **An EC2 Autoscaling Group - with Amazon Linux 2 EC2 Image**

The EC2 Image can be changed/adapted as needed.

## Database Tier
The database tier contains the following:
  - **A Private Subnet**
  - **A Security Group**
  - **An RDS Instance - with mysql engine**

The RDS Engine can be changed/adapted as needed.

# Pre-requistites
The following are pre-requistes that are necessary to successfully use this package and deploy the desired infrastructure:
  - [**A GitHub Account**](https://docs.github.com/en/get-started/start-your-journey/creating-an-account-on-github)
  - [**An AWS Account**](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html)
  - [**AWS CLI**](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
  - [**Terraform**](https://developer.hashicorp.com/terraform/install)
  - [**Terraform CLI**](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

# Usage
