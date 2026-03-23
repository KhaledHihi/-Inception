FROM debian:bullseye

# Install nginx and openssl (for TLS)
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/khhihi.key \
    -out /etc/nginx/ssl/khhihi.crt \
    -subj "/C=MA/ST=Khouribga/L=Khouribga/O=42/CN=khhihi.42.fr"

# Copy nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf
# Expose HTTPS port
EXPOSE 443
# Run nginx in foreground (PID 1)
CMD ["nginx", "-g", "daemon off;"]