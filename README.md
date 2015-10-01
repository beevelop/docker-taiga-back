[![](https://badge.imagelayers.io/beevelop/taiga-back:latest.svg)](https://imagelayers.io/?images=beevelop/taiga-back:latest 'Get your own badge on imagelayers.io')

# beevelop/taiga-back (adapted from htdvisser/taiga-back)
> [Taiga](https://taiga.io/) is a project management platform for startups and agile developers & designers who want a simple, beautiful tool that makes work truly enjoyable.

This Docker image can be used for running the Taiga backend. It works together with the [htdvisser/taiga-front-dist](https://registry.hub.docker.com/u/htdvisser/taiga-front-dist/) image.

## Running
A [postgres](https://registry.hub.docker.com/_/postgres/) container should be linked to the taiga-back container. The taiga-back container will use the ``POSTGRES_USER`` and ``POSTGRES_PASSWORD`` environment variables that are supplied to the postgres container.

```
docker run --name taiga_back_container --link postgres_container:postgres beevelop/taiga-back
```

## Docker-compose
For a complete taiga installation (``beevelop/taiga-back`` and ``htdvisser/taiga-front-dist``) you can use this docker-compose configuration:

```
data:
  image: tianon/true
  volumes:
    - /var/lib/postgresql/data
    - /usr/local/taiga/media
    - /usr/local/taiga/static
    - /usr/local/taiga/logs
db:
  image: postgres
  environment:
    POSTGRES_USER: taiga
    POSTGRES_PASSWORD: Un1c0rn
  volumes_from:
    - data
taigaback:
  image: beevelop/taiga-back
  hostname: taiga.example.com
  environment:
    SECRET_KEY: Un1c0rns_4r3_4w3s0m3
    EMAIL_USE_TLS: True
    EMAIL_HOST: smtp.gmail.com
    EMAIL_PORT: 587
    EMAIL_HOST_USER: youremail@gmail.com
    EMAIL_HOST_PASSWORD: yourpassword
  links:
    - db:postgres
  volumes_from:
    - data
taigafront:
  image: htdvisser/taiga-front-dist:stable
  hostname: taiga.example.com
  links:
    - taigaback
  volumes_from:
    - data
  ports:
    - 0.0.0.0:80:80
```

## Environment

* ``SECRET_KEY`` defaults to ``"insecurekey"``, but you might want to change this.
* ``PUBLIC_REGISTER_ENABLED`` defaults to ``True``

* `FEEDBACK_ENABLED`: enables Feedback functionality (default: True)
* `FEEDBACK_EMAIL`: (default *support@taiga.io*)

### URLs for static files and media files from taiga-back:
* ``MEDIA_URL`` defaults to ``"$API_SCHEME://$HOSTNAME/media/"``
* ``STATIC_URL`` defaults to ``"$API_SCHEME://$HOSTNAME/media/"``

### Domain configuration
* ``API_SCHEME`` defaults to ``"http"``. Use ``https`` if ``htdvisser/taiga-front-dist`` is used and SSL enabled.
* ``API_DOMAIN`` defaults to ``"$HOSTNAME"``
* ``FRONT_SCHEME`` defaults to ``"http"``. Use ``https`` if ``htdvisser/taiga-front-dist`` is used and SSL enabled.
* ``FRONT_DOMAIN`` defaults to ``"$HOSTNAME"``

### Database
If you want to use an existing PostgreSQL database, you can specify the database connection with the following environment variables
* ``DB_HOST``
* ``DB_USER``
* ``DB_NAME``
* ``DB_PASS``
* ``DB_PORT`` (default: 5432)

### Email configuration
* ``EMAIL_USE_TLS`` defaults to ``False``
* ``EMAIL_HOST`` defaults to ``"localhost"``
* ``EMAIL_PORT`` defaults to ``"25"``
* ``EMAIL_HOST_USER`` defaults to ``""``
* ``EMAIL_HOST_PASSWORD`` defaults to ``""``
* ``DEFAULT_FROM_EMAIL`` defaults to ``"no-reply@example.com"``

### Sample data
* ``SAMPLE_DATA``: set to any value (e.g. True) to initialize the Database with sample data

### Debugging
* ``DEBUG_ENTRYPOINT``: set to True to enable Debugging (`set -x`)
* ``DEBUG`` defaults to ``False``
* ``TEMPLATE_DEBUG`` defaults to ``False``
