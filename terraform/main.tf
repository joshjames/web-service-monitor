# terraform/main.tf

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}

# Local variable parsing from the central config file
locals {
  config = yamldecode(file("${path.module}/../config/config.yaml"))
}

# Configuration entry point for the Ingress Layer (Nginx/HAProxy/etc.)
module "edge_server" {
  source            = "./modules/edge_server"
  environment       = local.config.global.environment
  engine            = local.config.edge_tier.engine
  listen_port       = local.config.edge_tier.listen_port
  simulate_failures = local.config.edge_tier.simulate_failures
}

# Configuration entry point for the Log Processing and RegEx Pipeline Agent
module "collector" {
  source        = "./modules/collector"
  environment   = local.config.global.environment
  collector     = local.config.telemetry.collector
  target_events = local.config.telemetry.target_events
  log_source    = module.edge_server.log_volume_path
}

# Configuration entry point for the Central Dashboard Workspace
module "monitoring" {
  source        = "./modules/monitoring"
  environment   = local.config.global.environment
  window_period = local.config.telemetry.thresholds.window_period
  error_limit   = local.config.telemetry.thresholds.critical_error_count
}