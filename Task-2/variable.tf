# ---> Variables <---
variable "InstanceTag" {
  type    = string
  default = "Abhi"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "pub_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "pvt_cidr" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}
# ----------> AVAILABILITY ZONES <----------
variable "availability_zones" {
  type    = list(any)
  default = ["us-east-2a", "us-east-2b"]
}
# -------->  AMAZON MACHINE IMAGES <----------
variable "ami" {
  type    = list(any)
  default = ["ami-0578f2b35d0328762", "ami-06d5c50c30a35fb88"]
}
variable "nametag" {
  description = "Write the owner name"  
}