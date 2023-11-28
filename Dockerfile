# Use the official Ubuntu base image
FROM ubuntu:latest

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx

# Install openssl
RUN apt-get install openssl -y

RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/ 

# Create the htpasswd file for basic authentication
RUN echo "admin:$(openssl passwd -apr1 'admin')" > /etc/nginx/.htpasswd

# Expose ports 80 and 443 for the container
EXPOSE 80 443

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
