FROM python:3.4-slim

MAINTAINER Maik Hummel <m@ikhummel.com>

WORKDIR /usr/local/taiga

RUN buildDeps='build-essential binutils-doc autoconf flex bison libjpeg-dev libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev automake libtool libffi-dev curl git libxml2-dev libxslt-dev libpq-dev'; \
    set -x && \
    apt-get update -qq && \
    apt-get install -y $buildDeps && \
    apt-get install -y netcat gettext moreutils --no-install-recommends && \
    pip install circus gunicorn && \
  
    useradd -d `pwd` taiga && \
    mkdir media static logs taiga-back && \

    curl -sL 'https://github.com/taigaio/taiga-back/tarball/stable' | tar xz -C taiga-back --strip-components=1 && \
    cd taiga-back && \
    pip install -r requirements.txt && \

  # clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get purge -y --auto-remove $buildDeps && \
    apt-get autoremove -y && \
    apt-get clean

# Add Taiga Configuration
ADD ./dockerenv.py taiga-back/settings/dockerenv.py

# Configure and Start scripts
ADD ./circus.ini circus.ini
ADD ./conf.env conf.env
ADD ./start start

RUN chmod +x conf.env start

VOLUME /usr/local/taiga/media
VOLUME /usr/local/taiga/static
VOLUME /usr/local/taiga/logs

EXPOSE 8000

CMD ["/usr/local/taiga/start"]
