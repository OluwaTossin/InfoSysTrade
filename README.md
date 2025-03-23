# 🚀 AWS Terraform Cloud Architecture Deployment

## **1️⃣ Prerequisites**
Before deploying, ensure you have the following:
- **Terraform Installed** → [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- **AWS CLI Installed & Configured**
  ```sh
  aws configure
  ```
  (You need **AWS Access Key, Secret Key, and Region**)
- **Terraform State Storage (S3 + DynamoDB)**
  ```sh
  aws s3 mb s3://my-terraform-state-bucket
  aws dynamodb create-table --table-name terraform-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
  ```
  This ensures **Terraform manages state remotely instead of locally**.

---

## **2️⃣ Steps to Deploy the Infrastructure**
### **Step 1: Clone the Repository**
```sh
git clone https://github.com/OluwaTossin/InfoSysTrade.git
cd InfoSysTrade
```

### **Step 2: Initialize Terraform**
```sh
terraform init
```
✅ **This downloads necessary plugins and configures Terraform backend.**  

### **Step 3: Validate Terraform Configuration**
```sh
terraform validate
```
✅ **Checks for syntax errors and misconfigurations.**  

### **Step 4: Plan the Infrastructure Deployment**
```sh
terraform plan -out=tfplan
```
✅ **Generates an execution plan showing what Terraform will create.**  

### **Step 5: Apply Terraform Configuration**
```sh
terraform apply tfplan
```
⏳ **Wait for a few minutes while Terraform provisions AWS resources.**  

### **Step 6: Verify the Deployment**
- **Check AWS Console for created resources.**
- **Retrieve important outputs (like ALB DNS, VPC ID, RDS Endpoint)**:
  ```sh
  terraform output
  ```

---

## **3️⃣ Destroying the Infrastructure**
If you need to **remove all resources**, run:
```sh
terraform destroy -auto-approve
```
✅ **This will clean up all AWS resources created by Terraform**.

---

## **4️⃣ Notes & Best Practices**
✅ **Use `terraform fmt`** to format Terraform code properly:
```sh
terraform fmt
```
✅ **Ensure Terraform state is stored securely** (S3 + DynamoDB).  
✅ **Use version control (GitHub, GitLab) for tracking infrastructure changes.**  

---
