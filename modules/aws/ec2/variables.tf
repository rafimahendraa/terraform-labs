variable "name" {
  description = "EC2 instance name."
  type        = string
}

variable "ami" {
  description = "AMI ID."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs."
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP."
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
