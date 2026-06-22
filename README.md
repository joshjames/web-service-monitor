# Web Service Monitor


# Abstract Edge Telemetry Fabric & Anomaly Interception Engine
[![Telemetry Sandbox Pipeline](https://github.com/joshjames/web-service-monitor/actions/workflows/deploy.yml/badge.svg)](https://github.com/joshjames/web-service-monitor/actions)
[![IaC: Terraform](https://img.shields.io/badge/IaC-Terraform_1.7+-7B42BC?logo=terraform)](https://www.terraform.io/)
[![Observability: Vector](https://img.shields.io/badge/Telemetry-Vector-D8622A?logo=datadog)](https://vector.dev/)

A declarative, engine-agnostic platform engineering factory that injects high-performance stream processing agents directly into the web ingress tier. This repository uses **Terraform** to abstract cloud vs. local resource boundaries, providing a unified `config.yaml` schema that builds real-time regex stream pipelines to intercept, isolate, and alert on edge anomalies (`501 Not Implemented`, `502 Bad Gateway`, `504 Gateway Timeout`) before upstream telemetry layers saturate.

## Architectural Features
* **Environment-Agnostic Abstraction:** Single declaration file drives conditional provider maps switching between standalone local containers, Kubernetes Helm matrices, and AWS Application Load Balancers (ALB).
* **VRL Stream Interception:** Powered by Vector Remap Language (VRL) for zero-allocation log streaming, filtering out raw `200 OK` background noise at the collection edge to minimize storage and monitoring costs.
* **Declarative Observability:** Instantly builds threshold-driven Prometheus metrics and structured Grafana visualization panels straight from edge compute footprints.
* **Deterministic Verification Engine:** Automated GitHub Actions runner instantiates an isolated local sandbox, triggers an intentional chaos failure loop, and asserts metrics generation accuracy on every commit.

---
```
## Repository Layout
web-service-monitor/
├── .github/workflows/
│   └── deploy.yml          # CI/CD validation engine & test automation runner
├── terraform/
│   ├── main.tf             # Root execution matrix and conditional logic
│   ├── providers.tf        # Decoupled cloud/local engine provider blocks
│   ├── variables.tf        # Core typed variables matching config schema
│   └── modules/
│       ├── edge_server/    # Web proxy generation (Nginx, HAProxy, etc.)
│       ├── collector/      # Vector/Promtail event-driven ingestion engines
│       └── monitoring/     # Prometheus stack & Grafana dashboard compilation
├── config/
│   └── config.yaml         # Central source-of-truth configuration blueprint
└── README.md
```

---

## Core Configuration Matrix (`config/config.yaml`)
To adjust runtime profiles, swap the edge engine, or adjust alerting parameters, update this single file:

```yaml
global:
  environment: "local-sandbox"   # Options: local-sandbox, kubernetes, aws
  project_name: "edge-anomaly-monitor"

edge_tier:
  engine: "nginx"               # Options: nginx, haproxy, npm, aws-alb
  listen_port: 8080
  simulate_failures: true       # Instantiates an intentional broken upstream target

telemetry:
  collector: "vector"           # Options: vector, promtail, alloy
  target_events:
    - "501"
    - "502"
    - "504"
  thresholds:
    window_period: "1m"
    critical_error_count: 5     # Triggers alert state if limit is breached

  ```

Local Sandbox Installation & Execution
1. Prerequisites
Ensure your local terminal has the following bin footprints:

Terraform 1.7.0+

Docker Engine & Compose V2

2. Stand Up the Infrastructure
Clone the engine repository and run the underlying Terraform compilation layer:

Bash```
git clone [https://github.com/joshjames/web-service-monitor.git](https://github.com/joshjames/web-service-monitor.git)
cd web-service-monitor/terraform
```

# Initialize providers and compile module blocks
```
terraform init
terraform apply -auto-approve
```
3. Trigger Chaos Failure Ingress Simulation
Once the containers are up, execute an automated connection loop hitting the deliberately unmapped or broken upstream route to generate anomalous web logs:

Bash
```
echo "Injecting 10 edge failure requests..."
for i in {1..10}; do 
  curl -i http://localhost:8080/broken-upstream-route
  sleep 0.2
done
```
4. Assert Edge Collection Ingress
Query the local Vector scraping endpoint to verify that the parsing engine cleanly extracted the telemetry codes and incremented the Prometheus metrics structure:

Bash
```
curl -s http://localhost:9598/metrics | grep "fabric_edge_http_anomaly_total"
```
Expected metric assertion payload:

Plaintext
```
# HELP fabric_edge_http_anomaly_total Total count of monitored HTTP edge anomalies intercepted.
# TYPE fabric_edge_http_anomaly_total counter
fabric_edge_http_anomaly_total{status="HTTP_502",path="/broken-upstream-route"} 10
```
Production Cloud Portability Pathway
To upgrade the telemetry fabric from a local testing container mesh into a live enterprise environment:

Open config/config.yaml.

Update global.environment to aws or kubernetes.

Update edge_tier.engine to aws-alb.

Run terraform apply. The root deployment schema automatically drops local container bindings, mapping the identical metric transformation configurations out to an AWS ALB log stream, EC2-hosted collection agents, and Amazon Managed Grafana spaces.