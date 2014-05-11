---
layout: post
title: 'How-to install nginx'
comments: true
tags:
 - bash
 - command
 - how_to
 - installation
 - linux
 - ubuntu
 - nginx
 - pcre
 - reload
 - run
 - script
 - stop
 - zlib
---

Since there is so much buzz around [nginx](http://nginx.org/), I wanted to give
it a try on my small home server. The server is running a desktop edition of
Ubuntu 10.04 (I keep it as backup machine in case my laptop breaks), so keep
this in mind. The following bash script will download nginx version 1.1.12, its
dependencies and install it. Also, a user nginx will be created.

{% highlight bash %}
# Start by creating an appropriate user
useradd -r nginx
mkdir /home/nginx
chown nginx:nginx /home/nginx/

# Retrieve nginx dependencies
cd /home/nginx
mkdir library
cd library
wget http://zlib.net/zlib-1.2.5.tar.gz
tar xfz zlib-1.2.5.tar.gz
rm zlib-1.2.5.tar.gz
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.21.tar.gz
tar xfz pcre-8.21.tar.gz
rm pcre-8.21.tar.gz
cd ..

# Installing nginx
wget http://nginx.org/download/nginx-1.1.12.tar.gz
tar xfz nginx-1.1.12.tar.gz
rm nginx-1.1.12.tar.gz
cd nginx-1.1.12
./configure --prefix=/home/nginx \
    --user=nginx \
    --group=nginx \
    --with-pcre=../library/pcre-8.21/ \
    --with-zlib=../library/zlib-1.2.5/
make
make install
cd ..
rm -rf nginx-1.1.12/
chown -R nginx:nginx *
sed -i 's/listen\s*80;/listen 8080;/g' conf/nginx.conf
export NGINX_HOME='/home/nginx/'
export NGINX_PID_FILE=$NGINX_HOME'logs/nginx.pid'
{% endhighlight %}

In case you encounter any problems, please refer to the short, but sufficient,
[official documentation](http://nginx.org/en/docs/install.html). If it worked
out for you, you can now use the following commands to start and stop the server
as well as to reload the config.

{% highlight bash %}
# Start nginx (runs on port 8080)
su nginx -c $NGINX_HOME'sbin/nginx'

# Reload nginx config
kill -HUP $(cat $NGINX_PID_FILE)

# Stop nginx
kill -QUIT $(cat $NGINX_PID_FILE)
{% endhighlight %}

Check out the following blog if you need an [init script for nginx](http://articles.slicehost.com/2007/10/17/ubuntu-lts-adding-an-nginx-init-script).