# -DEVOPS--Ecommerce
terraform show -json | jq -r '.values.root_module.child_modules[].resources[] | select(.address == "module.jenkins.aws_instance.jenkins") | .values.public_ip' | xargs -I {} echo "[any]" > -./IAC/Ansible/Inventory/hosts.ini && terraform show -json | jq -r '.values.root_module.child_modules[].resources[] | select(.address == "module.jenkins.aws_instance.jenkins") | .values.public_ip' >> ./IAC/Ansible/Inventory/hosts.ini

ansible-playbook \
  --private-key Inventory/jenkins.pem \
  -i Inventory/hosts.ini \
  -u ubuntu \
  playbook/jenkins-playbook.yaml

aws eks update-kubeconfig --region us-east-1 --name open-tele-eks 
istioctl install --set profile=demo -y

chmod 400 IAC/Ansible/Inventory/jenkins.pem
ssh-keygen -y -f IAC/Ansible/Inventory/jenkins.pem