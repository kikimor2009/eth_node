variable "profile" {
  type    = string
  default = "az"
}

variable "region" {
  type    = string
  default = "eu-south-2"
}

variable "instance_type" {
  type    = string
  default = "m5.2xlarge"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ebs_params" {
  type = object({
    size       = number
    type       = string
    iops       = number
    throughput = number
  })
  default = {
    size       = 1500
    type       = "gp3"
    iops       = 16000
    throughput = 1000
  }
}

variable "ebs_mount_path" {
  description = "Path on the node, where to mount ebs volume"
  type        = string
  default     = "/mnt/data"
}

variable "bucket_name" {
  description = "Unique name of the S3 bucket"
  type        = string
  default     = "azbykovskyi-terraform-state"
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "terraform-state-lock"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    project     = "testnet_eth_node"
    environment = "development"
  }
}
