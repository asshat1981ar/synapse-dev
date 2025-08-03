terraform {
  required_providers {
    neon = {
      source  = "kislerdm/neon"
      version = "~> 0.1"
    }
  }
}

provider "neon" {
  # The API key is sourced from the NEON_API_KEY environment variable.
}

resource "neon_project" "synapse_project" {
  name = var.project_name
}
