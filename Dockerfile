FROM centos:7

LABEL creator Matthew Bingham

## Install basic Web server and install following packages

RUN yum -y install httpd \
      python3 \
      python3-pip \
      python3-six \
      epel-release \
      wget \
      bzip2\
      createrepo_c\
      && pip3 install --no-cache-dir --upgrade pip \
      && pip3 install --no-cache-dir \
        six

## Set working directory to tmp

WORKDIR /tmp

## Copy the generate_updateinfo.py to tmp directory

COPY generate_updateinfo.py /tmp

## Make the following directories in the webservers directory

RUN mkdir /var/www/html/errata5 \
          /var/www/html/errata6 \
          /var/www/html/errata7 \
          /var/www/html/errata8

## create the following empty errata repos for the different versions

RUN createrepo_c -v /var/www/html/errata5 \
 && createrepo_c -v /var/www/html/errata6 \
 && createrepo_c -v /var/www/html/errata7 \
 && createrepo_c -v /var/www/html/errata8

## Run wget to get the latest errata from Steve Mier and unzip
## Generate update information

RUN wget http://cefs.steve-meier.de/errata.latest.xml.bz2 \
 && bzip2 -dc errata.latest.xml.bz2 > errata.latest.xml \
 && chmod 755 generate_updateinfo.py \
 && ./generate_updateinfo.py -s all -t all -v -d ./ errata.latest.xml \
 && rm -rf errata.latest.xml* \
 && mv /tmp/updateinfo-5/updateinfo.xml /var/www/html/errata5/repodata/ \
 && mv /tmp/updateinfo-6/updateinfo.xml /var/www/html/errata6/repodata/ \
 && mv /tmp/updateinfo-7/updateinfo.xml /var/www/html/errata7/repodata/ \
 && mv /tmp/updateinfo-8/updateinfo.xml /var/www/html/errata8/repodata/

## modify repo data

RUN modifyrepo_c /var/www/html/errata5/repodata/updateinfo.xml /var/www/html/errata5/repodata \
 && modifyrepo_c /var/www/html/errata6/repodata/updateinfo.xml /var/www/html/errata6/repodata \
 && modifyrepo_c /var/www/html/errata7/repodata/updateinfo.xml /var/www/html/errata7/repodata \
 && modifyrepo_c /var/www/html/errata8/repodata/updateinfo.xml /var/www/html/errata8/repodata

## start the web server

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

