FROM ubuntu
MAINTAINER Tim Glabisch <docker@tim.ainfach.de>
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Basic Requirements
RUN apt-get -y install mysql-client apache2 libapache2-mod-php5 pwgen python-setuptools curl unzip make openssh-server curl vim git

# ssh
RUN mkdir -p /var/run/sshd

# ssh config
RUN echo "root:dev" | chpasswd

# php mods
RUN apt-get -y install php5-fpm php5-mysql php-apc php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

# php debug
RUN pecl install xdebug
# Enable XDebug
RUN echo zend_extension=`find /usr/lib/ -iname xdebug.so` > /etc/php5/conf.d/_xdebug.ini
ADD ./server/xdebug.ini /etc/php5/conf.d/xdebug.ini
# Patch Xdebug remote host :)
RUN sed -i "s/\[REMOTE\_HOST\]/`ip route | awk '/^default/ {print $3}'`/g" /etc/php5/conf.d/xdebug.ini
RUN ip route | awk '/^default/ {print $3}' > /etc/docker_host

# php config
ADD ./server/php.ini /etc/php5/apache2/php.ini

#RUN sed -i s/[]// /etc/php5/conf.d/_xdebug.ini

# apache
RUN chown -R www-data:www-data /var/www/

# apache config
ADD ./server/apache-vhost /etc/apache2/sites-enabled/000-default

RUN a2enmod rewrite

# php fpm
# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
cap


RUN /usr/bin/easy_install supervisor

ADD ./server/supervisord.conf /etc/supervisord.conf

# expose
EXPOSE 80
EXPOSE 22
EXPOSE 3306

ADD ./server/start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/bin/bash", "/start.sh"]
