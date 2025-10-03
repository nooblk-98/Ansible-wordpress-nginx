# Deploy WordPress & PhpMyAdmin on AWS VPS with Terraform & Ansible

This guide walks you through deploying a VPS on AWS using **Terraform** and installing WordPress (with PhpMyAdmin) using **Ansible**. It covers all steps, file structure, and debug commands for troubleshooting.

---

<p align="center">
  <img src="https://logo.svgcdn.com/l/terraform-icon-8x.png" alt="Terraform" height="40"/>
  <img src="https://www.ibm.com/adobe/dynamicmedia/deliver/dm-aid--4316b0f6-521f-42dc-9167-f66f24f94f0a/ansible.png" alt="Ansible" height="40"/>
  <img src="https://a0.awsstatic.com/libra-css/images/logos/aws_logo_smile_1200x630.png" alt="AWS" height="40"/>
  <img src="https://raw.githubusercontent.com/Azure/azure-docs/master/articles/includes/media/azure-logo.png" alt="Azure" height="40"/>
</p>


## 1️⃣ Prerequisites

- AWS account & credentials
- SSH key for your VPS (EC2)
- Terraform installed ([Download](https://www.terraform.io/downloads.html))
- Ansible installed ([Install Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))
- Python 3 installed on your local machine

---

## 2️⃣ Deploy VPS Infrastructure with Terraform

### a. Configure AWS Credentials

Set up your AWS CLI:
```sh
aws configure
```
Or export credentials:
```sh
export AWS_ACCESS_KEY_ID="<your-access-key>"
export AWS_SECRET_ACCESS_KEY="<your-secret-key>"
export AWS_DEFAULT_REGION="<your-region>"
```

### b. Edit Terraform Variables

Open `infra/terraform.tfvars` and set:
```hcl
ec2_name = "wordpress-application"
key_name = "your-ec2-keypair-name"
```
Make sure `key_name` matches an existing EC2 key pair in AWS.

### c. Initialize & Apply Terraform

```sh
cd infra
terraform init
terraform plan
terraform apply
```
Confirm when prompted. This will create your VPC, subnet, security groups, EC2 instance, and Elastic IP.

### d. Get Your VPS Public IP

After deployment, find your public IP:
```sh
terraform output ec2_public_ip
```
Or check in AWS EC2 console.

---

## 3️⃣ Install WordPress & PhpMyAdmin with Ansible

### a. Configure Inventory

Edit `ansible/inventory.ini`:
```ini
[wordpress_servers]
wp1 ansible_host=<YOUR_VPS_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem

[wordpress_servers:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3
ansible_become=true
ansible_become_method=sudo
```

### b. Review Configuration Files

- `ansible/ansible.cfg`: Points to inventory and sets connection options.
- `ansible/roles/app/files/.env`: Contains WordPress, DB, and admin secrets.
- `ansible/roles/app/files/docker-compose.yml`: Defines WordPress, MariaDB, Autoheal containers.
- **PhpMyAdmin is accessible via Nginx reverse proxy at `/phpmyadmin`**.

### c. Change Domain & SSL Details

To change your domain and SSL email for Nginx and Certbot, edit:
```
ansible/playbooks/roles/nginx/defaults/main.yml
```
Example:
```yaml
site_domain: yourdomain.com
certbot_email: youremail@example.com
backend_host: 127.0.0.1
backend_port: 8080
```

### d. Run Ansible Playbook

From the `ansible` directory:
```sh
ansible-playbook -i inventory.ini playbooks/deploy_wordpress.yml
```

---

## 4️⃣ Debugging & Useful Commands

### Terraform

- Show outputs:
  ```sh
  terraform output
  ```
- Show resources:
  ```sh
  terraform state list
  ```
- Destroy infrastructure:
  ```sh
  terraform destroy
  ```

### Ansible

- Test SSH connection:
  ```sh
  ansible wordpress_servers -m ping -i inventory.ini
  ```
- Run playbook with debug output:
  ```sh
  ansible-playbook -i inventory.ini playbooks/deploy_wordpress.yml -vvv
  ```
- Check facts:
  ```sh
  ansible wordpress_servers -m setup -i inventory.ini
  ```
- SSH manually for troubleshooting:
  ```sh
  ssh -i ~/.ssh/your-key.pem ubuntu@<YOUR_VPS_IP>
  ```

---

## 5️⃣ Accessing Your Application

- **WordPress:** https://<YOUR_DOMAIN>
- **PhpMyAdmin:** https://<YOUR_DOMAIN>/phpmyadmin
- **Credentials:** See Ansible output or check `/opt/wordpress/.env` on the VPS.

---

## 6️⃣ File Structure Reference

```
ansible/
  ├─ roles/
  │   ├─ app/
  │   │   ├─ files/
  │   │   │   ├─ docker-compose.yml
  │   │   │   ├─ .env
  │   │   └─ tasks/
  │   │       └─ main.yml
  │   └─ nginx/
  │       ├─ tasks/
  │       │   └─ main.yml
  │       ├─ defaults/
  │       │   └─ main.yml
  │       └─ templates/
  │           └─ nginx-site.conf.j2
  ├─ playbooks/
  │   └─ deploy_wordpress.yml
  ├─ inventory.ini
  ├─ ansible.cfg
  └─ deploy.sh
infra/
  ├─ main.tf
  ├─ variables.tf
  ├─ outputs.tf
  ├─ terraform.tfvars
  └─ ...
```

---

## 7️⃣ Troubleshooting Tips

- **SSH Issues:** Check security group rules, key path, and user in `inventory.ini`.
- **Docker Issues:** Ensure Docker is running: `sudo systemctl status docker`
- **Ansible Errors:** Use `-vvv` for verbose output.
- **Site Not Loading:** Check firewall/security group for open ports (80, 443, 8080).
- **Role/Path Issues:** Ensure roles are in `ansible/roles/`.
- **Nginx/SSL Issues:** Edit `ansible/playbooks/roles/nginx/defaults/main.yml` for domain/email changes.

---

## 8️⃣ References

- [Terraform Docs](https://www.terraform.io/docs)
- [Ansible Docs](https://docs.ansible.com/)
- [Docker Docs](https://docs.docker.com/)
- [WordPress Docs](https://wordpress.org/support/article/installing-wordpress/)

---

**Happy Deploying! 🚀**

