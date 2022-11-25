# // Installing Nginx For Handle GRPC
installType='apt -y install'
source /etc/os-release
release=$ID
ver=$VERSION_ID

if [[ "${release}" == "debian" ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y
		echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
		echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
		curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
		# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
		sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
		sudo apt update
                apt -y install nginx

elif [[ "${release}" == "ubuntu" ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y
		echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
		echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
		curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
		# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
		sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
		sudo apt update
                apt -y install nginx
fi

systemctl daemon-reload
systemctl enable nginx
rm -rf /etc/nginx/sites-*;

cat <<EOF >>/etc/nginx/nginx.conf
#user nobody nogroup; #表示以默认用户（root）运行。若取消注释，注意修改为相应权限的用户与组。
worker_processes auto;

error_log /var/log/nginx/error.log; #错误日志的文件地址

pid /run/nginx.pid;

events {
    worker_connections 1024;
}
stream {
    map $ssl_preread_server_name $backend_name {
        zv.${domain}  vless; # VLESS TCP XTLS
        zt.${domain} trojan; # TROJAN TCP XTLS
        zh.${domain}  https; # HTTPS SERVER WEB GRPC H2
    }
    upstream vless {
        server 127.0.0.1:5443; # PORT VLESS XTLS
    }
    upstream trojan {
        server 127.0.0.1:6443; # PORT TROJAN XTLS 
    }
    upstream https {
        server 127.0.0.1:7443; # PORT WEB GRPC H2
    }
    server {
        listen 443;
        listen [::]:443; 
        ssl_preread on;
        proxy_pass $backend_name;
        proxy_protocol on; 
    }
}
http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;

	autoindex on;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;

	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;

	fastcgi_read_timeout 600;

	set_real_ip_from 204.93.240.0/24;
	set_real_ip_from 204.93.177.0/24;
	set_real_ip_from 199.27.128.0/21;
	set_real_ip_from 173.245.48.0/20;
	set_real_ip_from 103.21.244.0/22;
	set_real_ip_from 103.22.200.0/22;
	set_real_ip_from 103.31.4.0/22;
	set_real_ip_from 141.101.64.0/18;
	set_real_ip_from 108.162.192.0/18;
	set_real_ip_from 190.93.240.0/20;
	set_real_ip_from 188.114.96.0/20;
	set_real_ip_from 197.234.240.0/22;
	set_real_ip_from 198.41.128.0/17;
	real_ip_header     CF-Connecting-IP;

  include /etc/nginx/conf.d/*.conf;
}
EOF
