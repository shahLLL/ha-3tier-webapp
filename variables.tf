variable "vpc_name" {
    description = "Value of the VPC's name tag"
    type = string
    default = "main-vpc"
}

variable "vpc_cidr_block" {
    description = "Value of the VPC's cidr block"
    type = string
    default = "10.0.0.0/16"
}
