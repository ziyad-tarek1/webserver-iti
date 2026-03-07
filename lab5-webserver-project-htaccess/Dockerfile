# =============================================================================
# LAB 5: Apache .htaccess Demo - Minimal Dockerfile
# =============================================================================
# All Apache config is in config/httpd-custom.conf (mod_rewrite, AllowOverride, etc.)
# =============================================================================

FROM httpd:2.4-alpine
RUN apk add --no-cache wget
COPY config/httpd-custom.conf /usr/local/apache2/conf/extra/httpd-custom.conf
RUN echo 'Include conf/extra/httpd-custom.conf' >> /usr/local/apache2/conf/httpd.conf
CMD ["httpd-foreground"]
