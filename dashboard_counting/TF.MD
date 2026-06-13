terraform init
terraform fmt
terraform validate


terraform plan
terraform apply
terraform destroy


terraform output
terraform state list

terraform state rm <resource>


ssh -i dashboard-counting-app.pem ubuntu@ec2-13-214-202-14.ap-southeast-1.compute.amazonaws.com

scp -i dashboard-counting-app.pem dashboard-counting-app.pem ubuntu@ec2-13-214-202-14.ap-southeast-1.compute.amazonaws.com:/home/ubuntu/

curl -v http://172.16.2.60:9000 


scp -i dashboard-counting-app.pem dashboard-counting-app.pem ubuntu@52.77.220.170:/home/ubuntu/

# Replace <COUNTING_PRIVATE_IP> with the actual IP (e.g., 172.16.2.x)
curl -v http://172.16.2.184:9000
ssh -i "dashboard-counting-app-ssh-key.pem" ubuntu@ec2-13-214-202-14.ap-southeast-1.compute.amazonaws.com

ssh -i dashboard-counting-app.pem ubuntu@52.77.220.170




ssh -i dashboard-counting-app.pem ubuntu@54.169.200.93

cat /var/log/dashboard-service.log


cat /usr/lib/systemd/system/dashboard-api.service | grep COUNTING

sudo systemctl status dashboard-api.service

curl http://172.16.2.190:9000


ssh -i dashboard-counting-app.pem ubuntu@172.16.2.190

scp -i dashboard-counting-app.pem dashboard-counting-app.pem  ubuntu@172.16.2.190

scp -i dashboard-counting-app.pem dashboard-counting-app.pem  ubuntu@54.169.200.93:/home/ubuntu/