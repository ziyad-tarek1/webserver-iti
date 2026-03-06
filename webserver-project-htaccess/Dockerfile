# Production-grade Apache with .htaccess support
# Pin version for reproducible builds
FROM httpd:2.4-alpine

# wget for container healthcheck (minimal footprint)
RUN apk add --no-cache wget

# Enable mod_rewrite (required for RewriteRule in .htaccess)
RUN sed -i 's/#LoadModule rewrite_module /LoadModule rewrite_module /' /usr/local/apache2/conf/httpd.conf

# Add custom config: AllowOverride, security headers, custom error pages
COPY config/httpd-custom.conf /usr/local/apache2/conf/extra/httpd-custom.conf
RUN echo 'Include conf/extra/httpd-custom.conf' >> /usr/local/apache2/conf/httpd.conf

# Entrypoint generates .htpasswd from env vars (keeps credentials out of image)
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["httpd-foreground"]
