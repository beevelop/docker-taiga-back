FROM python:3-alpine

MAINTAINER Maik Hummel <m@ikhummel.com>

ENV TAIGA_VERSION 1.10.0

WORKDIR /opt/taiga

COPY circus.ini conf.env start /opt/

RUN buildDeps='binutils-doc autoconf flex bison libjpeg freetype-dev zlib-dev gdbm-dev ncurses5 automake libtool libffi-dev curl git gcc musl-dev g++ linux-headers postgresql-dev' && \
    apk add --no-cache $buildDeps && \

    echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache netcat-openbsd gettext moreutils@testing libpq libxslt-dev libxml2-dev libjpeg libzmq tar && \
    
    pip install circus==0.14 && \
    
    mkdir -p media static logs taiga-back && \
    chmod a+x /opt/conf.env /opt/start && \

    curl -sL "https://api.github.com/repos/taigaio/taiga-back/tarball/${TAIGA_VERSION}" | tar xz -C taiga-back --strip-components=1 && \
    cd taiga-back && \
    pip install -r requirements.txt && \

    apk del --no-cache $buildDeps

COPY dockerenv.py taiga-back/settings/dockerenv.py

VOLUME /opt/taiga/media /opt/taiga/static /opt/taiga/logs

EXPOSE 8000

CMD /opt/start
