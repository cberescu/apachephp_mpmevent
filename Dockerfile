FROM centos:latest
MAINTAINER Ciprian ciprian@systemapi.com
LABEL name="ApachePhp_MpmEvent" \
    vendor="CentOS" \
    license="GPLv2" \
    build-date="2016-05-16"
#update everything
RUN yum -y update 

#install stuff
RUN yum install -y epel-release
RUN yum install -y curl httpd wget supervisor.noarch
RUN wget https://centos7.iuscommunity.org/ius-release.rpm && rpm -Uvh ius-release.rpm
RUN yum install -y php56u php56u-fpm php56u-mysql php56-curl php56-gd

# for remi RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && rpm -Uvh remi-release-7*.rpm epel-release-7*.rpm

#the mount is on /app, and create simlink
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
RUN chown apache:apache /app -R

#allow .htacces override
RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf

#enable mpm_event
RUN echo "LoadModule mpm_event_module modules/mod_mpm_event.so" > /etc/httpd/conf.modules.d/00-mpm.conf

#add config for supervisor
ADD supervisord.ini /etc/supervisord.d/supervisord.ini
#add config for mpm_event
ADD mpm_event.conf /etc/httpd/conf.d/mpm_event.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
