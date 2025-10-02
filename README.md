# 🚀 DevOps Project: Production-Grade React App on AWS

This project demonstrates a **production-ready DevOps pipeline** for deploying a **React application (Dockerized)** on **AWS** using **Terraform** (Infrastructure as Code), **Ansible** (configuration management), and **GitHub Actions** (CI/CD).

The deployment architecture includes **VPC, private/public subnets, Auto Scaling Group, Application Load Balancer, HTTPS with ACM, CloudWatch monitoring, and Terraform remote state management**.

---

## 🎯 Project Objectives

* Build and push **Dockerized React app** to **Amazon ECR**.
* Deploy app on **EC2 Auto Scaling Group** behind an **Application Load Balancer (ALB)**.
* Manage infrastructure using **Terraform modules** with **remote state (S3 + DynamoDB)**.
* Configure EC2 instances using **Ansible** (Docker setup, image pull, container run).
* Automate build/test/deploy pipelines with **GitHub Actions**.
* Implement **monitoring, logging, and alerts** with AWS CloudWatch.
* Ensure **zero-downtime deployments** and **production security practices**.

---

## 🏗️ High-Level Architecture

```
                     ┌───────────────────────┐
                     │      GitHub Actions    │
                     │  (CI/CD pipelines)     │
                     └──────────┬────────────┘
                                │
                                ▼
┌───────────────┐   ┌───────────────────────┐
│   Developer   │ → │   Amazon ECR           │
│   (React App) │   │   (Docker Images)      │
└───────────────┘   └───────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────┐
│                  AWS VPC                    │
│ ┌──────────────┐       ┌──────────────────┐ │
│ │   ALB (HTTPS)│──────▶│ Auto Scaling     │ │
│ │              │       │ Group (EC2+Docker)│ │
│ └──────────────┘       └──────────────────┘ │
│        │                          │          │
│        ▼                          ▼          │
│   CloudWatch Logs          CloudWatch Alarms │
└─────────────────────────────────────────────┘
```

---

## 📂 Repository Structure

```
Production-Grade-React-App-on-AWS/
├─ app/                         # React app (Dockerized)
│  ├─ Dockerfile
│  ├─ src/
│  └─ package.json
├─ infra/                       # Terraform IaC
│  ├─ envs/
│  │  ├─ dev/
│  │  └─ prod/
│  ├─ modules/
│  │  ├─ vpc/
│  │  ├─ alb/
│  │  ├─ asg/
│  │  ├─ ecr/
│  │  └─ observability/
│  ├─ backend/
│  └─ main.tf
├─ ansible/                     # Configuration management
│  ├─ roles/
│  │  ├─ docker/
│  │  └─ app/
│  └─ playbooks/
│     └─ site.yml
├─ .github/workflows/           # GitHub Actions pipelines
│  ├─ ci.yml
│  └─ cd.yml
└─ README.md
```

---

## 🛠️ Tools & Technologies

* **AWS**: VPC, ALB, EC2, Auto Scaling, ECR, ACM, Route53, CloudWatch
* **Terraform**: Infrastructure as Code (IaC), remote state, modules
* **Ansible**: Config management & deployment automation
* **GitHub Actions**: CI/CD pipelines
* **Docker**: Containerization of React app
* **Monitoring**: CloudWatch logs & alarms
* **Security**: IAM least privilege, HTTPS, secrets via Parameter Store

---

## 📌 Milestones & Workflow

1. **Setup AWS Account & CLI**: Create an AWS account, configure CLI with access keys.
2. **Clone Repo**: `git clone https://github.com/yourusername/Production-Grade-React-App-on-AWS.git`
3. **Build React App**: Develop your React app in the `app/` directory.
4. **Configure Infrastructure**:
    * Update Terraform variables in `infra/envs/dev/` or `infra/envs/prod/`.
    * Configure backend S3 bucket and DynamoDB table for Terraform state.
5. **Deploy Infrastructure**:
    * Navigate to `infra/`.
    * Run `terraform init`, `terraform plan`, and `terraform apply`.
6. **Configure Ansible**:
    * Update Ansible inventory and variables in `ansible/`.
7. **Deploy App**:
    * Navigate to `ansible/playbooks/`.
    * Run `ansible-playbook -i inventory site.yml`.
8. **Setup CI/CD**:
    * Configure GitHub Secrets for AWS credentials, ECR, etc.
    * Update GitHub Actions workflows in `.github/workflows/`.
9. **Monitor & Optimize**: Use CloudWatch to monitor logs, set up alarms, and optimize resources.
10. **Security Review**: Ensure IAM roles, security groups, and other settings follow best security practices.

---

## 📚 References & Learning Resources

* **AWS Documentation**: For services like EC2, S3, IAM, etc.
* **Terraform Documentation**: Learn about modules, remote state, etc.
* **Ansible Documentation**: For configuration management and playbook authoring.
* **GitHub Actions Documentation**: Understand CI/CD pipeline configuration.
* **Docker Documentation**: Learn about containerizing applications.
* **React Documentation**: For building and optimizing React applications.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repo.
2. Create a new branch: `git checkout -b feature/YourFeature`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/YourFeature`.
5. Create a pull request.

Please ensure your code adheres to the project's coding standards and includes appropriate tests.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Happy Coding!** 🚀

