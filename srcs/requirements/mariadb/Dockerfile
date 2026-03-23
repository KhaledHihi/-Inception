FROM debian:bullseye
#Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*
#copy from my files to container image
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /setup.sh

#Executes during image build time (docker build).
RUN chmod +x /setup.sh  

EXPOSE 3306
#Specifies the default command to run during container runtime (docker run).
CMD ["/setup.sh"] 

#Docker send SIGTERM l-PID 1 (setup.sh) Setup.sh receive signal → dead properly ✅