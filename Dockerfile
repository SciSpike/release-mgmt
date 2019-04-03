FROM node:8-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
      bash \
      git \
      openssh

RUN npm i -g fx ymlx

RUN mkdir /scripts
COPY ./match /scripts/match
RUN chmod +x /scripts/match
RUN ln -s /scripts/match /usr/local/bin/match

RUN mkdir /gitrepo
VOLUME [ "/gitrepo" ]
WORKDIR /gitrepo

COPY ./release* /scripts/
RUN rm /scripts/release-this

RUN chmod +x /scripts/*

ENTRYPOINT [ "/scripts/release" ]
CMD [ "--help" ]
