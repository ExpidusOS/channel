terraform {
  required_version = ">= 1.0.1"

  backend "local" {
    path = "local_tf_state/terraform-main.tfstate"
  }
}
