FROM     ubuntu:14.04.1

MAINTAINER Sergey Holota serg.holota@gmail.com

# ---------------- #
#   Installation   #
# ---------------- #

# Install all prerequisites
RUN     apt-get -y install software-properties-common
RUN     add-apt-repository -y ppa:chris-lea/node.js
RUN     apt-get -y update
RUN     apt-get -y install python-django-tagging python-simplejson python-memcache python-ldap python-cairo \ 
		python-pysqlite2 python-support python-pip gunicorn supervisor nodejs git wget curl \
		openjdk-7-jre build-essential python-dev libfontconfig adduser openssl ca-certificates

RUN     pip install Twisted==11.1.0
RUN     pip install Django==1.5

# Checkout the stable branches of Graphite, Carbon and Whisper and install from there
RUN     mkdir /src
RUN     git clone https://github.com/graphite-project/whisper.git /src/whisper            &&\
        cd /src/whisper                                                                   &&\
        git checkout 0.9.x                                                                &&\
        python setup.py install

RUN     git clone https://github.com/graphite-project/carbon.git /src/carbon              &&\
        cd /src/carbon                                                                    &&\
        git checkout 0.9.x                                                                &&\
        python setup.py install 

RUN     git clone https://github.com/graphite-project/graphite-web.git /src/graphite-web  &&\
        cd /src/graphite-web                                                              &&\
        git checkout 0.9.x                                                                &&\
        python setup.py install

# Install Grafana 2.1
RUN     wget http://grafanarel.s3.amazonaws.com/builds/grafana_latest_amd64.deb
RUN     dpkg -i grafana_latest_amd64.deb && rm grafana_latest_amd64.deb 

# ----------------- #
#   Configuration   #
# ----------------- #

# Configure Whisper, Carbon and Graphite-Web
ADD     ./graphite/initial_data.json /opt/graphite/webapp/graphite/initial_data.json
ADD     ./graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
RUN     mkdir -p /opt/graphite/storage/whisper
RUN     touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index
RUN     chown -R www-data /opt/graphite/storage
RUN     chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
RUN     chmod 0664 /opt/graphite/storage/graphite.db
RUN     cd /opt/graphite/webapp/graphite && python manage.py syncdb --noinput

# Configure Grafana

ADD    ./defaults.ini /etc/grafana/conf/defaults.ini

ADD    ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ---------------- #
#   Expose Ports   #
# ---------------- #

WORKDIR /usr/share/grafana
EXPOSE 3000/tcp


# -------- #
#   Run!   #
# -------- #

CMD     ["/usr/bin/supervisord"]
