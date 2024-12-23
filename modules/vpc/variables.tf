variable "vpc-cidr" {
    type = string
  
}

variable "subnets" {
    type = map(object({
        cidr = string
        public = bool
        az = string
    }))
  
}

variable "route-cidr" {
    type = string
  
}