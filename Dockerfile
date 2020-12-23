FROM debian:buster

RUN apt update && \
	apt install -y mariadb-server php-fpm nginx php-mysqli wget unzip vim && \
	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip && \
	wget wordpress.org/latest.tar.gz && \
	unzip phpMyAdmin-4.9.0.1-all-languages.zip && \
	tar xvf latest.tar.gz && \
	rm phpMyAdmin-4.9.0.1-all-languages.zip latest.tar.gz && \
	mv phpMyAdmin-4.9.0.1-all-languages phpmyadmin && \
	mv phpmyadmin /var/www && \
	mv wordpress /var/www && \
	mkdir ssl && \
	openssl req -keyout server.key -new -x509 -days 365 -out server.cr -nodes -subj "/C=RU" && \
	mv server.* ssl
COPY srcs/nginx.conf /etc/nginx 
COPY srcs/wp-config.php var/www/wordpress
CMD service mysql start && \
	mysql -e "create database wordpress;" && \
	mysql -e "grant all on wordpress.* to 'admin' identified by 'admin';" && \
	mysql -e "flush privileges;" && \
	service php7.3-fpm start && \
	nginx && \
	bash
