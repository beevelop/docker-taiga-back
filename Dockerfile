FROM python:3.4-slim

MAINTAINER Maik Hummel <m@ikhummel.com>

WORKDIR /usr/local/taiga

RUN \
  apt-get update -qq && \
  apt-get install -y netcat gettext moreutils && \
  rm -rf /var/lib/apt/lists/* && \
  pip install circus gunicorn && \
  
  useradd -d `pwd` taiga && \
  mkdir media static logs taiga-back && \

  curl -sL 'https://github.com/taigaio/taiga-back/tarball/stable' | tar xz -C taiga-back --strip-components=1 && \
  cd taiga-back && \
  pip install -r requirements.txt

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
