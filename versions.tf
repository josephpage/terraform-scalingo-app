terraform {
  required_version = ">= 1.3.9, < 2.0.0"

  required_providers {
    scalingo = {
      source  = "Scalingo/scalingo"
      version = "~> 2.0"
    }
  }
}
