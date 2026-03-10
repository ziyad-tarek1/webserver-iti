# Lab 5.1 - Apache Load Balancer
FROM httpd:2.4-alpine
COPY config/httpd-proxy.conf /usr/local/apache2/conf/extra/httpd-proxy.conf
RUN echo 'Include conf/extra/httpd-proxy.conf' >> /usr/local/apache2/conf/httpd.conf
