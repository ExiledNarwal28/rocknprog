# Rock n' Prog blog

This is my personal blog for programming and dev-related things. It uses Docker and Jekyll.

Base repo was copied from [Joel Capillo's Dockerized Jekyll and Nginx](https://github.com/hunyoboy/dockerized-jekyll-nginx).

Next, a lot of things were copied from [dwalkr's Multilingual Jekyll site](https://github.com/dwalkr/jekyll-multilingual).

## Dependencies

 - Docker
 - Docker Compose

## Project setup

### Start development environment

```shell
docker-compose -f docker-compose-dev.yml up --build; docker-compose -f docker-compose-dev.yml down
```

### Start production environment

Push to master. The rest is magic.
