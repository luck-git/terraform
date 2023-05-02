#!/bash/bin
yum update -y
yum install nginx -y 
systemctl start nginx
systemctl enable nginx 
echo "hello from terraform" > /usr/share/nginx/html/index.html