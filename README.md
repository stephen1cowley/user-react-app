# Programming Agent UI

## Description

Your Programming Agent allows you to discuss with an AI chatbot what sort of custom web app you'd like it to create for you. Within a few seconds you'll see the results! 

This repo contains the code of the user app Docker container (editted live by the AI).

For the backend repo, see the [Programming Agent Server](https://github.com/stephen1cowley/programming-agent-server). For the main frontend repo, see the [Programming Agent UI](https://github.com/stephen1cowley/programming-agent-ui).

## Features
See [Programming Agent Server](https://github.com/stephen1cowley/programming-agent-server) for a detailed description of the app's features and usage examples.

## Architecture

See [Programming Agent Server](https://github.com/stephen1cowley/programming-agent-server) for a detailed description of the app's network and services architecture.


## Installation
### Prerequisites
- Docker engine installed (see [Docker docs](https://docs.docker.com/engine/install/))
- Basic knowledge of Docker 

To build the docker image:
```
docker build -t programming-agent-image .
```

To run the docker image:
```
docker run -d -p 3000:3000 programming-agent-image
```

Alternatively to run containers on AWS, use the functions in [Programming Agent Server](https://github.com/stephen1cowley/programming-agent-server) which automatically build and push a docker container to AWS ECR and run it on ECS Fargate. But this is not necessary.
