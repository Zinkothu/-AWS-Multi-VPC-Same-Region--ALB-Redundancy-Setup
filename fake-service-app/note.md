ssh -i fake-service-app.pem ubuntu@13.214.184.215

sco -i 
curl http://192.168.2.15:9092


curl http://172.16.2.90:9091


curl http://13.214.184.215:9091


sudo systemctl daemon-reload
sudo systemctl restart dashboard-api.service
sudo systemctl status dashboard-api.service



terraform taint aws_instance.account_app
terraform taint aws_instance.account_app
terraform taint aws_instance.statement_app

terraform apply