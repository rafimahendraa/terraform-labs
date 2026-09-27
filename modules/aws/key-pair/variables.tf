variable "name" {
  description = "Key pair name."
  type        = string
}

variable "public_key" {
  description = "SSH public key."
  type        = string
}

variable "common_tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
