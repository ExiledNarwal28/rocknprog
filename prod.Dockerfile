FROM jekyll/jekyll:latest

MAINTAINER Fabien Roy

CMD jekyll build

FROM nginx:1.19.6

COPY web/_site /var/www/public
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/html/404.html /usr/share/nginx/html/404.html

CMD nginx -g 'daemon off;'