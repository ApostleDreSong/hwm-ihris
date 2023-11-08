#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update package list and install Nginx
apt update
apt install -y nginx

# Enable Nginx to start at boot
systemctl enable nginx

# Create a directory for SSL certificates
mkdir -p /etc/nginx/ssl

# Write the content of your SSL certificate and private key to files
cat <<EOF > /etc/nginx/ssl/shwfr.org.ng.crt
-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----
EOF

cat <<EOF > /etc/nginx/ssl/shwfr.org.ng.key
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2t56eG8Sq62B0
gvguLcjE2xpIaIbed8VGMB1HGs8sk9j6I6VW//w6cWbECpekeNcU2fXBgJi4B7WX
/+/Kz5ClFpn6+vcdXQsjbv1abZRptp6IQYqbJPALotV0knu/ETGKutMWhj1ieJGt
dcX01/9BVE9k406oBYVwUTyLX1k+Y/aHZVO6tbv6dJBZfKxpV28zTvg0/MNtbUJV
54PmZevqbegzyIwngmWoJ5NVVxqyYOIJ4gOMlBPyiqHiwRGpsKD9a31K9OipHxxe
vSmEBJQw/8J/OPm+2G7wPVSmTD5fO/A+5Dg/nlO9ykTRSro+4CzytSxdqZEZbdxp
VcwmNBGxAgMBAAECggEAAIuUGYeOjt5CkJxwsEYWk5hOB/XoY57uv7SubK80u67C
Aq6TLGsZggTjPC3mKZFq/mLfXe1D32Y1/XLwAK5dgZGbgmVH8h5sRWX8E25Q518a
MmDEMK3zuawp6AX1ILME32Oq9DXwtlPS5vYrUd2IY2X0kfHv8tZH4Xe7lxSg8fvF
8/XG7SScE/zXDcJYDTGzASJk3jHNqfvB9IGNwWYnhrrDY0kWy6kcUziBhGhKJtP5
98uwuThOTNXOpYz+Znv0DEbPgerefB1asyIsVUWV9qjgG8v8veI5Md8p6FTj0oFl
MICfSRGMiLs6xNYt1po2ToWOZsEY5tHxOSr7ebSAwQKBgQD2l5jpkknfU1b9vPZY
3uw4BE2PPnLp/hOeVvIBY45Na1etrHQbAY6wAkmi55anHepq/dbiVf2DwBW524dW
x/HJdrp2/8nC3otp4f0Q+tU8Lruzm725TXj/i5UK1wV/yj0Poswn+pP2O/0tSRUh
WPwQl9flZ7a8CYUl15XyhE/bQQKBgQC9sCwfpaIkr7tCI5Jv9mn5TbzDlIuB2C0h
umLhuV4OvDug0NSKWQuzQCV2JYQoe6ss+axcz3ZiMicKvX1fmtbvcUcHd8F9BxXc
4jQ8R4L6awlfajADVQdMlDawvUvxXNS7mXocStIbCIhy1UQDYV25tPVueuZwC/DW
fydSjjPKcQKBgQDX7i/seDlP4f6O+mUNtUdMVhhEkv61f9NWF/Sa2r7FdHW2kwio
jViRL6+jgwAdHskjH1yHnZz9PbrIoT+F8lf7fogRpDLc/Vs/QLEFqWAH7zRWNs6P
8RM/Us8USu151XJausfjSj0+pZExkol6Rh2TuiNHsuYFCqEZXgrj7pCvAQKBgEEk
AOMVVGtY1evOn3lHm/j7UzmvB4GdpVIR2ec+ayiQR8HgNT0Ve0khXDwIgiwM3Cnj
y+dLb5IlOvcbP7TXTbyIoCXWYGH5Tu6918ZjoH0yyNM1eiuKxajstSNYvn2yrXOH
L0IMB7803PbieirXAwLFPAumtQABecGPhQd6whphAoGBAItZh7r2+U+5PmTfXbIP
CwBJRkMGAKxsAVIBdXru9AJdGt6HMjSlcMWCLDsjHCmlBYc7cks0vqgk0qnR77zt
9yChVi3oPcBdI5ajKFrUF5hPmnJL/PKMxiTwKWGKTGB22OAUKSdQrniczgmZTd/V
25p4/hHMV7ESvBRsypiNlkGP
-----END PRIVATE KEY-----
EOF

# Create a Nginx configuration file for your subdomain
cat <<EOF > /etc/nginx/modules-available/nginx.conf
  user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        client_max_body_size 200M;

        ##
        # Gzip Settings
        ##

        gzip on;

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

          # HTTP server block (Listen on port 80)
    server {
        listen 80;
        server_name bauchi.shwfr.org.ng, fct.shwfr.org.ng, ebonyi.shwfr.org.ng, sokoto.shwfr.org.ng, kebbi.shwfr.org.ng;

        # Redirect all HTTP traffic to HTTPS
        return 301 https://\$host\$request_uri;
    }

    server {
        listen 443 ssl;
        server_name bauchi.shwfr.org.ng;

        # SSL certificate files
        ssl_certificate /etc/nginx/ssl/shwfr.org.ng.crt;
        ssl_certificate_key /etc/nginx/ssl/shwfr.org.ng.key;

        # Additional SSL settings
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';
        ssl_prefer_server_ciphers off;

        location / {
            proxy_pass http://localhost:3000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }

    server {
        listen 443 ssl;
        server_name ebonyi.shwfr.org.ng;

        # SSL certificate files
        ssl_certificate /etc/nginx/ssl/shwfr.org.ng.crt;
        ssl_certificate_key /etc/nginx/ssl/shwfr.org.ng.key;

        # Additional SSL settings
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';
        ssl_prefer_server_ciphers off;

        location / {
            add_header Content-Type text/html;
            return 200 "Ebonyi iHRIS coming soon";
            #proxy_pass http://localhost:3001;
            #proxy_set_header Host \$host;
            #proxy_set_header X-Real-IP \$remote_addr;
            #proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }

     server {
        listen 443 ssl;
        server_name fct.shwfr.org.ng;

        # SSL certificate files
        ssl_certificate /etc/nginx/ssl/shwfr.org.ng.crt;
        ssl_certificate_key /etc/nginx/ssl/shwfr.org.ng.key;

        # Additional SSL settings
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';
        ssl_prefer_server_ciphers off;

        location / {
            add_header Content-Type text/html;
            return 200 "FCT iHRIS coming soon";
            #proxy_pass http://localhost:3002;
            #proxy_set_header Host \$host;
            #proxy_set_header X-Real-IP \$remote_addr;
            #proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }

      server {
        listen 443 ssl;
        server_name kebbi.shwfr.org.ng;

        # SSL certificate files
        ssl_certificate /etc/nginx/ssl/shwfr.org.ng.crt;
        ssl_certificate_key /etc/nginx/ssl/shwfr.org.ng.key;

        # Additional SSL settings
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';
        ssl_prefer_server_ciphers off;

        location / {
           add_header Content-Type text/html;
            return 200 "Kebbi iHRIS coming soon";
            #proxy_pass http://localhost:3003;
            #proxy_set_header Host \$host;
            #proxy_set_header X-Real-IP \$remote_addr;
            #proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }

     server {
        listen 443 ssl;
        server_name sokoto.shwfr.org.ng;

        # SSL certificate files
        ssl_certificate /etc/nginx/ssl/shwfr.org.ng.crt;
        ssl_certificate_key /etc/nginx/ssl/shwfr.org.ng.key;

        # Additional SSL settings
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';
        ssl_prefer_server_ciphers off;

        location / {
            add_header Content-Type text/html;
            return 200 "Sokoto iHRIS coming soon";
            #proxy_pass http://localhost:3004;
            #proxy_set_header Host \$host;
            #proxy_set_header X-Real-IP \$remote_addr;
            #proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
}


#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
# 
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
EOF

# Create a symbolic link to enable the subdomain site
ln -s /etc/nginx/sites-available/subdomain.conf /etc/nginx/sites-enabled/

# Test Nginx configuration
nginx -t

# Reload Nginx to apply changes
systemctl reload nginx

echo "Nginx installed and configured for HTTP to HTTPS redirection with custom SSL certificate."
