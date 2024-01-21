variable "account_id" {
  description = "AWS Account id"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "shard_short_id" {
  description = "Shorten shard id"
}

variable "cidr_numeral" {
  description = "The VPC CIDR numeral (10.x.0.0/16)"
}

variable "aws_region" {
  default = "cn-north-1"
}

variable "env_suffix" {
  description = "The name of the VPC which is also the environment name"
}

variable "availability_zones" {
  description = "A comma-delimited list of availability zones for the VPC."
}

variable "subnet_no_private" {
  description = "This value means the number of private subnets"
  default     = "3"
}

variable "cidr_numeral_public" {
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}

variable "cidr_numeral_private" {
  default = {
    "0" = "80"
    "1" = "96"
    "2" = "112"
    "3" = "128"
    "4" = "144"
    # This is for migration. it uses 24 bit mask
    "5"  = "48"
    "6"  = "49"
    "7"  = "50"
    "8"  = "51"
    "9"  = "52"
    "10" = "53"
    "11" = "54"
    "12" = "55"
    "13" = "56"
    "14" = "57"
    "15" = "58"
    "16" = "59"
    "17" = "60"
    "18" = "61"
    "19" = "62"
    "20" = "63"
    "21" = "64"
    "22" = "65"
    "23" = "66"
    "24" = "67"
    "25" = "68"
    "26" = "69"
    "27" = "70"
    "28" = "71"
    "29" = "72"
    "30" = "73"
    "31" = "74"
    "32" = "75"
    "33" = "76"
    "34" = "77"
    "35" = "78"
    "36" = "79"
    "37" = "208"
    "38" = "209"
    "39" = "210"
  }
}

variable "cidr_numeral_private_db" {
  default = {
    "0" = "160"
    "1" = "176"
    "2" = "192"
  }
}