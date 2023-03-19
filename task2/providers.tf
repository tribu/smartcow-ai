
provider "aws" {
  region = var.region
}

terraform {
  required_version = "= 1.3.8"
}