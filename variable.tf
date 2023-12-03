variable "ubuntu_ami" {
  description = "This is a variable to manage ec2 AMI type"
  type        = string
  default     = "ami-0694d931cee176e7d"
}

variable "VPC_value" {
  description = "This is a variable to manage the VPC"
  type        = string
  default     = "vpc-0de121ec0ecf8eeb6"
}

variable "ec2_key_name" {
  description = "This is a variable to manage ec2 key name"
  type        = string
  default     = "test100"
}

variable "ec2_instance_type" {
  description = "This is a variable to manage ec2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "DB-engine" {
  description = "This variable will manage the name of the DB engine"
  type        = string
  default     = "postgres"
}

variable "DB-instance_class" {
  description = "This variable will manage the instance type for DB"
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "This variable will manage the database version for DB set up"
  type        = string
  default     = "15.3"
}

variable "identifier" {
  description = "This variable will manage the database identifier for DB set up"
  type        = string
  default     = "cicd-database"
}


variable "certificate_arn" {
  description = "This variable will manage the HTPPS listener cert arn"
  type        = string
  default     = "arn:aws:acm:eu-west-1:622658514249:certificate/ca534fd3-96a8-494a-b182-6b71bad9696f"
}
