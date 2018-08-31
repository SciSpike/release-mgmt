FROM alpine:3.8

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
      bash \
      git \
      openssh \
      nodejs \
      npm

RUN npm i -g ymlx

RUN mkdir /scripts
COPY docker/match /scripts/match
RUN chmod +x /scripts/match
RUN ln -s /scripts/match /usr/local/bin/match

RUN mkdir /gitrepo
VOLUME [ "/gitrepo" ]
WORKDIR /gitrepo

COPY release-image-codefresh /scripts/release-image-codefresh
RUN chmod +x /scripts/release-image-codefresh
RUN ln -s /scripts/release-image-codefresh /usr/local/bin/release-image-codefresh

ENTRYPOINT [ "release-image-codefresh" ]
CMD [ "--help" ]
