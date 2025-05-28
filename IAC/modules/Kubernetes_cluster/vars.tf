variable "node_groups" {
  description = "values for node groups_name"
  type = map(object({
      name =  string,
      subnet_ids = list(string)
    }))
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type = list(string)
}

variable "ec_frontend_sg_id" {
  description = "Security group ID"
  type = string
}