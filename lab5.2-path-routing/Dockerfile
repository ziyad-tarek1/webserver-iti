# Lab 5.2 - Apache Path-Based Routing
FROM httpd:2.4-alpine
COPY config/httpd-proxy.conf /usr/local/apache2/conf/extra/httpd-proxy.conf
RUN echo 'Include conf/extra/httpd-proxy.conf' >> /usr/local/apache2/conf/httpd.conf
