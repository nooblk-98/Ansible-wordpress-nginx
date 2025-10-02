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
- **Inventory Parsing Issues:**
    - If you see warnings about "No inventory was parsed" or "provided hosts list is empty", make sure:
      - You are in the `ansible` directory.
      - `inventory.ini` exists and is not empty.
      - You can also specify the inventory file directly:
        ```sh
        ansible -i inventory.ini wordpress_servers -m ping
        ```
- **Role Not Found:**
    - Ensure your roles are located in `ansible/roles/` (e.g., `ansible/roles/docker`, `ansible/roles/app`).
    - If you are already inside the `ansible` folder and your roles are in `ansible/roles/`, you do **not** need to specify `--roles-path`.
    - Only use `--roles-path` if your roles are outside the default `roles` directory.
    - Or move your roles into the default `ansible/roles/` directory.
- **World Writable Directory Warning:**
    - If you see a warning like:
      ```
      Ansible is being run in a world writable directory ... ignoring it as an ansible.cfg source.
      ```
    - This means your `ansible` folder permissions are too open.  
      To fix, run:
      ```sh
      chmod go-w /mnt/d/github/Production-Grade-React-App-on-AWSd/ansible
      ```
    - After fixing permissions, Ansible will use your `ansible.cfg` and inventory correctly.

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

# Production-Grade React App on AWS - Ansible Setup

## Prerequisites
- Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Ensure you have SSH access to your VPS and your private key file (e.g., `D:\ssh\ssh.pem`)
- Update `ansible/inventory.ini` with your VPS IP, SSH user, and private key path

## Steps

1. **Navigate to the Ansible directory:**
   ```sh
   cd ansible
   ```

2. **Test connection to your server:**
   ```sh
   ansible wordpress_servers -m ping
   ```
   > **Troubleshooting:**  
   > If you see warnings about "No inventory was parsed" or "provided hosts list is empty", make sure:
   > - You are in the `ansible` directory.
   > - `inventory.ini` exists and is not empty.
   > - You can also specify the inventory file directly:
   >   ```sh
   >   ansible -i inventory.ini wordpress_servers -m ping
   >   ```

3. **Run a playbook (example):**
   ```sh
   ansible-playbook playbooks/deploy_wordpress.yml
   ```
   - Replace `playbooks/deploy_wordpress.yml` with your actual playbook file name and path.
   > **Troubleshooting:**  
   > If you see an error like "the playbook could not be found", make sure:
   > - You are in the `ansible` directory.
   > - The playbook file exists at the specified path (e.g., `playbooks/deploy_wordpress.yml`).

## Configuration Files

- `ansible/inventory.ini`: Defines your server(s) and connection details.
- `ansible/ansible.cfg`: Sets Ansible options (user, key, timeouts, etc.).

## Troubleshooting

- Ensure your private key file path is correct and accessible.
- If you encounter permission errors, check your SSH user and key permissions.
- For more info, see [Ansible documentation](https://docs.ansible.com/).

---

**Happy Deploying! 🚀**

