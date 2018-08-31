FROM alpine:3.8

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
      bash \
      git \
      openssh \
      nodejs \
      npm

RUN npm i -g fx

RUN mkdir /scripts
COPY docker/match /scripts/match
RUN chmod +x /scripts/match
RUN ln -s /scripts/match /usr/local/bin/match

RUN mkdir /gitrepo
VOLUME [ "/gitrepo" ]
WORKDIR /gitrepo

COPY release-nodejs /scripts/release-nodejs
RUN chmod +x /scripts/release-nodejs
RUN ln -s /scripts/release-nodejs /usr/local/bin/release-nodejs

ENTRYPOINT [ "release-nodejs" ]
CMD [ "--help" ]
