
# 🚀 Production-Grade React App on AWS - Complete Manual Deployment Guide

This guide explains how to manually deploy the infrastructure and WordPress application using **Terraform** and **Ansible**.

---

## 1️⃣ Prerequisites

**Required:**
- AWS account & credentials
- VPS/EC2 instance (public IP, SSH access)
- SSH key for VPS
- Terraform installed ([Download](https://www.terraform.io/downloads.html))
- Ansible installed ([Install Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))
- Docker & Docker Compose (will be installed by Ansible)

---

## 2️⃣ Infrastructure Deployment (Terraform)

1. **Configure AWS Credentials**
     - Set up your AWS CLI: `aws configure`
     - Export credentials if needed:
         ```powershell
         $env:AWS_ACCESS_KEY_ID="<your-access-key>"
         $env:AWS_SECRET_ACCESS_KEY="<your-secret-key>"
         $env:AWS_DEFAULT_REGION="<your-region>"
         ```

2. **Edit Terraform Variables**
     - Open `infra/terraform.tfvars` and set your values (VPC, EC2, etc).

3. **Initialize & Apply Terraform**
     - Open terminal, go to `infra/` folder:
         ```powershell
         cd infra
         terraform init
         terraform plan
         terraform apply
         ```
     - Confirm when prompted. This will provision your AWS infrastructure.

4. **Note Your VPS/EC2 Public IP**
     - You’ll need this for Ansible inventory.

---

## 3️⃣ Application Deployment (Ansible)

1. **Configure Inventory**
     - Edit `ansible/inventory.ini`:
         ```ini
         [wordpress_servers]
         <YOUR_VPS_IP> ansible_host=<YOUR_VPS_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
     
         [wordpress_servers:vars]
         ansible_ssh_common_args='-o StrictHostKeyChecking=no'
         ansible_python_interpreter=/usr/bin/python3
         ```
     - Replace `<YOUR_VPS_IP>` and SSH key path with your actual values.

2. **Check Ansible Configuration**
     - Ensure `ansible.cfg` points to your inventory and uses correct user/key.

3. **Review Docker Compose Files**
     - WordPress deployment files are in `ansible/roles/app/files/`:
         - `docker-compose.yml` (WordPress, MySQL, PhpMyAdmin)
         - `.env` (database passwords)
         - `uploads.ini` (PHP config)

4. **Run Deployment Script**
     - From the `ansible/` folder, run:
         ```powershell
         ./deploy.sh
         ```
     - This will:
         - Test SSH connection
         - Install Docker & Docker Compose
         - Copy Docker Compose files
         - Generate secure DB passwords
         - Deploy WordPress stack

5. **Manual Playbook Run (Alternative)**
     - You can also run:
         ```powershell
         ansible-playbook -i inventory.ini playbooks/deploy_wordpress.yml
         ```

---

## 4️⃣ Accessing Your Application

- **WordPress:** http://<YOUR_VPS_IP>
- **PhpMyAdmin:** http://<YOUR_VPS_IP>:8080
- **Passwords:** See Ansible output for generated DB credentials

---

## 5️⃣ Troubleshooting

- **SSH Issues:**
    - Check IP, user, and SSH key path in `inventory.ini`
    - Ensure your VPS allows SSH (port 22)
- **Docker Issues:**
    - Ansible installs Docker & Compose automatically
    - Check service status: `sudo systemctl status docker`
- **WordPress Not Loading:**
    - Check Ansible output for errors
    - Ensure ports 80/443/8080 are open in security group/firewall

---

## 6️⃣ File Structure Reference

```
ansible/
    ├─ roles/
    │   └─ app/
    │       ├─ files/
    │       │   ├─ docker-compose.yml
    │       │   ├─ .env
    │       │   └─ uploads.ini
    │       └─ tasks/
    │           └─ main.yml
    ├─ playbooks/
    │   └─ deploy_wordpress.yml
    ├─ inventory.ini
    ├─ ansible.cfg
    └─ deploy.sh
infra/
    ├─ main.tf
    ├─ terraform.tfvars
    └─ ...
```

---

## 7️⃣ Useful Commands

- **Terraform:**
    - `terraform init` — Initialize working directory
    - `terraform plan` — Preview changes
    - `terraform apply` — Apply changes
- **Ansible:**
    - `ansible-playbook -i inventory.ini playbooks/deploy_wordpress.yml` — Deploy WordPress
    - `ansible wordpress_servers -m ping` — Test SSH connection

---

## 8️⃣ Security & Best Practices

- Change all default passwords
- Use SSH keys, not passwords
- Restrict security group/firewall rules
- Monitor resources and logs

---

## 9️⃣ References

- [Terraform Docs](https://www.terraform.io/docs)
- [Ansible Docs](https://docs.ansible.com/)
- [Docker Docs](https://docs.docker.com/)
- [WordPress Docs](https://wordpress.org/support/article/installing-wordpress/)

---

**Happy Deploying! 🚀**

