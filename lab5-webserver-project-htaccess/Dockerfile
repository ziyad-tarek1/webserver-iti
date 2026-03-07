# =============================================================================
# LAB 5: Apache with .htaccess Support - Dockerfile
# =============================================================================
# This Dockerfile builds an Apache image that supports .htaccess files.
# Students will learn: Basic Auth, URL redirects, per-directory configuration.
# =============================================================================

# Step 1: Use official Apache Alpine image (small, secure, reproducible)
# Alpine = minimal Linux = smaller image size
FROM httpd:2.4-alpine

# Step 2: Install wget - needed for Docker healthcheck to ping the server
# Healthcheck helps Docker/orchestrators know if the container is healthy
RUN apk add --no-cache wget

# Step 3: Enable mod_rewrite - REQUIRED for RewriteRule in .htaccess
# By default Apache has it commented out; we uncomment it
# Without this, our redirect (old-page -> public/) would NOT work
RUN sed -i 's/#LoadModule rewrite_module /LoadModule rewrite_module /' /usr/local/apache2/conf/httpd.conf

# Step 4: Add our custom Apache config
# This file enables AllowOverride (so .htaccess is read), security headers, error pages
COPY config/httpd-custom.conf /usr/local/apache2/conf/extra/httpd-custom.conf
RUN echo 'Include conf/extra/httpd-custom.conf' >> /usr/local/apache2/conf/httpd.conf

# Step 5: Start Apache (no entrypoint - we use .htpasswd file directly in htdocs/secure/)
CMD ["httpd-foreground"]
