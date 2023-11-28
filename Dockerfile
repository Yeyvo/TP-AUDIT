# Use the official Ubuntu base image
FROM ubuntu:latest

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx


RUN ln -s /etc/nginx/sites-available/site1-public.conf /etc/nginx/sites-enabled/ && \
    ln -s /etc/nginx/sites-available/site2-restricted.conf /etc/nginx/sites-enabled/


# Expose ports 80 and 443 for the container
EXPOSE 80 443

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
