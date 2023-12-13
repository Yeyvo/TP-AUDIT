# Use the official Ubuntu base image
FROM ubuntu:latest

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx

# Install openssl
RUN apt-get install openssl -y

# RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/nginx.conf 
# RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/ 

# Create the htpasswd file for basic authentication
RUN echo "laojdojal:$(openssl passwd -apr1 'admin')" > /etc/nginx/.htpasswd


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN grep -r default_server /etc/nginx

# Expose ports 80 and 443 for the container
EXPOSE 80 443

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
