# Ethereum RPC Node

## Overview

This repo stores code that will help you setup a new Ethereum RPC node.
Node will use PoS algorithm with [execution](https://geth.ethereum.org/) and [consensus](https://lighthouse.sigmaprime.io/client/get-started) clinets in Holesky testnet.

It uses terraform and ansible for node's provisioning. Provides one-click installation

### Prerequisites

Things that needs to be installed and configured before you start provision.

- terraform `v1.9.5`
- ansible `~>2.17`
- AWS IAM User with programatic access
- AWS VPC and public subnet

## Deploy guide

Deploy is done fully automatically. No manual actions are needed.
Terrafrom will start Ansible automation after the infra is ready.
To setup a complete stack with the network provisioning, check the `full_install` branch.

Note! This repo uses terraform with the s3 as remote backend. Disabled by default.
To store state remotely use this [guide](#Remote-state-setup)

### Complete provisioning

1. Provide required variables in `terraform.tfvars`(link)
2. (Optionaly) customise the installation, see variables.tf for options
3. Initialize the providers with `terraform init`
4. Review the planned changes by running `terraform plan`
5. Apply all the changes with `terraform apply`
6. Receive the EC2 Public IP as an output

### Destroy the infrastructure

Note! For safety reasons multiple as resorces has "prevent_destory" lifecycle.

- remove `prevent_destory` policies
- run `terraform destroy`

### Remote state setup

- provide unique bucket and table names to `terraform.tfvars`
- uncomment the s3 and dynamo db resources in `backend.tf`
- run tf plan only for 2 resources
    `terraform plan -target=aws_dynamodb_table.terraform_locks -target=aws_s3_bucket.terraform_state -out state_plan`
- run tf apply on new plan file
    `terraform plan state_plan`
- uncomment state config in terraform provider
- migrate the state to s3 with `terraform init`
- run regular `terraform plan` and `terraform apply`

### Ansible automation notes

Key points about full automation:

- dynamic inventory template based on terraform variables `inventory.tf`
- automatic ssh-key provision `inventory.tf` `instance.tf`
- terraform null_resource for ansible installation `run_ansible.tf`

## Outcome

By following these steps, you will easily spin up a complete Ethereum RPC node with AWS Infrastructure. Feel free to explore and customize this automation based to your needs.
In case of any problems, don't hesitate to reach me out

### To do leftovers

- Setup Monitoring (Prom/Grafana) and Logging (Loki) stacks
- Add eth node's metrics to prometheus
- Add ethereum clients' logs to the loki stack
- Add infrastructure diagram
- Improve ansible part to provision eth clients updates seamlessly
- Add github actions for code quality (ansible_lint, tf_lint, etc.)
- Move ethereum clients to separate roles. Consider other clients
- Run separate VMs for different roles
- Configure scaling and redundancy with AWS LB with multi-az ec2 setup
- Reseach ec2 tuning options for the node's best performance
