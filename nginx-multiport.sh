# Nginx Config By Manpokr@MANTERNET
# ============================================================
# Please do not try to change / modif this config
# This config is tag to xray if you modified this 
# Xray will Error / Crash
# Nginx TROJAN/VLESS/VMESS/SHADOWSOCK/SSHVPN GRPC/WS
# ============================================================
# (C) Copyright 2022-2023 By MANTERNET

server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;
             server_name ${domain};

             ssl_certificate /usr/local/etc/xray/xray.crt;
             ssl_certificate_key /usr/local/etc/xray/xray.key;

             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
             ssl_prefer_server_ciphers on;

# // WS TLS

       location = /vless {
            if (ddd != ggg) { 
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1101;
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }
        location = /vmess { 
            if (ddd != ggg) { 
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1102; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }
        location = /trojan { 
            if (ddd != ggg) { 
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1103; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }
        location = /shadowsock { 
            if (ddd != ggg) {
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1104; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }

# // WS NONE TLS

       location = /vless-none {
            if (ddd != ggg) { 
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1105;
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }
        location = /vmess-none { 
            if (ddd != ggg) { 
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1106; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }
        location = /trojan-none { 
            if (ddd != ggg) { 
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1107; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }
        location = /ss-none { 
            if (ddd != ggg) {
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1108; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }

# GRPC TLS

          location ^~ /vless-grpc {                                       
                if (hhh !~ iii/jjj) {                
                        return 404;                                       
                }                                                         
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
                grpc_set_header Host ccc;
                client_max_body_size 0;                                   
                client_body_timeout 1071906480m;                          
                grpc_read_timeout 1071906480m;                            
                grpc_pass grpc://127.0.0.1:1109;
 }
          location ^~ /vmess-grpc {                                       
                if (hhh !~ iii/jjj) {                
                        return 404;                                       
                }
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
                grpc_set_header Host ccc;
                client_max_body_size 0;
                client_body_timeout 1071906480m;                          
                grpc_read_timeout 1071906480m;                            
                grpc_pass grpc://127.0.0.1:1110;
 }
          location ^~ /trojan-grpc {                                       
                if (hhh !~ iii/jjj) {                
                        return 404;                                       
                }
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
                grpc_set_header Host ccc;
                client_max_body_size 0;
                client_body_timeout 1071906480m;                          
                grpc_read_timeout 1071906480m;                            
                grpc_pass grpc://127.0.0.1:1111;
 }
          location ^~ /ss-grpc {                                       
                if (hhh !~ iii/jjj) {                
                        return 404;                                       
                }                        
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
                grpc_set_header Host ccc;
                client_max_body_size 0;                                   
                client_body_timeout 1071906480m;                          
                grpc_read_timeout 1071906480m;                            
                grpc_pass grpc://127.0.0.1:1112;
 }
# // TROJANGO WS
        location = /trojango { 
            if (ddd != ggg) {
                return 404;
            }
            proxy_redirect off;
            proxy_pass http://127.0.0.1:1113; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade ddd;
            proxy_set_header Connection fff;
            proxy_set_header Host ccc;
            proxy_set_header X-Real-IP aaa;
            proxy_set_header X-Forwarded-For bbb;
 }
# // SSH WS
          location / {
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:700; # PORT WS PY
                      proxy_http_version 1.1;
                proxy_set_header X-Real-IP aaa;
                proxy_set_header X-Forwarded-For bbb;
                proxy_set_header Upgrade ddd;
                proxy_set_header Connection fff;
                proxy_set_header Host eee;
        }
  } 
# // OVPN WS TLS
    server {
        server_name ovpn.${domain};

        location / {
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:800; # PORT WS PY
                      proxy_http_version 1.1;
                proxy_set_header X-Real-IP aaa;
                proxy_set_header X-Forwarded-For bbb;
                proxy_set_header Upgrade ddd;
                proxy_set_header Connection fff;
                proxy_set_header Host eee;
        }
    }
EOF


# // Move
sed -i 's/aaa/$remote_addr/g' /etc/nginx/conf.d/alone.conf
sed -i 's/bbb/$proxy_add_x_forwarded_for/g' /etc/nginx/conf.d/alone.conf
sed -i 's/ccc/$host/g' /etc/nginx/conf.d/alone.conf
sed -i 's/ddd/$http_upgrade/g' /etc/nginx/conf.d/alone.conf
sed -i 's/eee/$http_host/g' /etc/nginx/conf.d/alone.conf
sed -i 's/fff/"upgrade"/g' /etc/nginx/conf.d/alone.conf
sed -i 's/ggg/"websocket"/g' /etc/nginx/conf.d/alone.conf
sed -i 's/hhh/$content_type/g' /etc/nginx/conf.d/alone.conf
sed -i 's/iii/"application/g' /etc/nginx/conf.d/alone.conf
sed -i 's/jjj/grpc"/g' /etc/nginx/conf.d/alone.conf
sed -i 's/zzz/$host$request_uri/g' /etc/nginx/conf.d/alone.conf
