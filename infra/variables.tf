# All the input variables, with validation blocks

variable "name_prefix" {
  description = "Prefix for every name. Lowercase letters, digits and hyphens, up to 12 characters."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{1,12}$", var.name_prefix))
    error_message = "name_prefix: lowercase letters, digits and hyphens, up to 12 characters."
  }
}

variable "env" {
  description = "Environment name. Only dev or prod."
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env must be either \"dev\" or \"prod\"."
  }
}

variable "vpc_cidr" {
  description = "CIDR range of the VPC. No default: set per environment in the tfvars."
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR (e.g. 10.10.0.0/16)."
  }
}

variable "image_tag" {
  description = "Image tag to deploy (git commit SHA, or 'none' when only building the network)."
  type        = string
}

variable "desired_count" {
  description = "Number of tasks per service (1 in dev, 2 in prod)."
  type        = number
  default     = 1
}

variable "option_a" {
  description = "First voting option."
  type        = string
  default     = "ביבי"
}

variable "option_b" {
  description = "Second voting option."
  type        = string
  default     = "אייזנקוט"
}
