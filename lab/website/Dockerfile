# Use a specific version of the Ubuntu base image to ensure consistency and predictability
FROM ubuntu:20.04


# Create a non-root user
# RUN groupadd -r nginx && useradd -r -g nginx -G root nginx

# Install nginx and openssl and Minimize the number of layers and install only necessary packages
RUN apt-get update && \
    apt-get install -y openssl nginx curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./nginx/site1-public /var/www/html/site1-public
COPY ./nginx/site2-restricted /var/www/html/site2-restricted
COPY ./nginx/site.conf /etc/nginx/nginx.conf
COPY /nginx/custom_index/index.html /var/www/html/index.html
COPY ./nginx/site_certificate.crt /etc/ssl/certs/site_certificate.crt
COPY ./nginx/site_private.key /etc/ssl/private/site_private.key


# Set permissions for the certificate
# RUN chmod 644 /etc/ssl/certs/site_certificate.crt

# Set permissions for the private key
# Be very cautious with this, consider the security implications
# RUN chown nginx.nginx /etc/ssl/private/site_private_key.key
# RUN chmod 640 /etc/ssl/private/site_private_key.key

# # Create the htpasswd file for basic authentication
RUN echo "admin:$(openssl passwd -apr1 'admin')" > /etc/nginx/.htpasswd


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN grep -r default_server /etc/nginx


# Set appropriate permissions
# RUN chown -R nginx:nginx /var/www/html && \
#     chmod -R 755 /var/www/html


# Expose ports 80 and 443 for the container
EXPOSE 80 443

# Switch to non-root user
# USER nginx

# Set logging level to INFO
ENV LOG_LEVEL info


# Start nginx in the foreground as non-root user
CMD ["nginx", "-g", "daemon off;"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -fk https://localhost/ || exit 1