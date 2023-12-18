# Use a specific version of the Ubuntu base image to ensure consistency and predictability
FROM ubuntu:20.04


# Create a non-root user
RUN groupadd -r nginx && useradd -r -g nginx nginx

# Install nginx and openssl and Minimize the number of layers and install only necessary packages
RUN apt-get update && \
    apt-get install -y nginx openssl \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/nginx.conf 
# RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/ 


# Use Docker Secrets for sensitive data
# RUN --mount=type=secret,id=my_secret,dst=/etc/nginx/.htpasswd \
#     echo "user:$(openssl passwd -apr1 $(< /etc/nginx/.htpasswd))" > /etc/nginx/.htpasswd


# # Create the htpasswd file for basic authentication
RUN echo "laojdojal:$(openssl passwd -apr1 'admin')" > /etc/nginx/.htpasswd


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN grep -r default_server /etc/nginx


# Set appropriate permissions
RUN chown -R nginx:nginx /var/www/html && \
    chmod -R 755 /var/www/html




# Expose ports 80 and 443 for the container
EXPOSE 80 443

# Switch to non-root user
USER nginx

# Limit resources
RUN ulimit -u 1024 -n 1024

# Set logging level to INFO
ENV LOG_LEVEL info


# Start nginx in the foreground as non-root user
CMD ["nginx", "-g", "daemon off;"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1