
🚀 Professional Private Cloud HA Cluster (M1 Mac)
 This repository contains a full-stack Infrastructure-as-Code (IaC) and Configuration Management (Ansible) lab. It simulates a production data center environment on a local M1 Mac.

🏗️ Architecture3-Node Cluster: 
Automated Ubuntu VMs via Multipass.Load Balancer: Nginx (Docker) on VM-01 distributing traffic to workers.Web Cluster: Redundant Apache servers on VM-02 and VM-03 (High Availability).Observability Hub: Centralized monitoring with Prometheus, Grafana, and Loki (Logs).

🛠️ Tech Stack & Skills MasteredProvisioning:
Terraform (Stateful management & Remote-exec)Configuration: Ansible (Dynamic Inventory, Playbooks, UFW Hardening)Containerization: Docker (Volumes for persistence, Restart policies)Networking: SSH ProxyJump (Bastion Host), Load Balancing, FirewallsDevSecOps: GitHub Actions with TruffleHog secret scanning and Terraform Validate

🚦 How to RunPrepare Host: 
colima start and multipass start --allDeploy Infra: terraform apply -auto-approve (Generates dynamic inventory.ini)Configure Nodes:ansible-playbook -i inventory.ini install_docker.ymlansible-playbook -i inventory.ini load_balancer.ymlMonitor: Access Grafana at http://192.168.2.12:3000 (admin/admin)

🌪️ Chaos Engineering Tested 
Successfully tested Zero Downtime: Stopped VM-02 and confirmed traffic automatically failed over to VM-03 via the Nginx Load Balancer