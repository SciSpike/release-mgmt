FROM alpine:3.8

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
      bash \
      git \
      openssh

RUN mkdir /scripts
COPY ./match /scripts/match
RUN chmod +x /scripts/match
RUN ln -s /scripts/match /usr/local/bin/match

RUN mkdir /gitrepo
VOLUME [ "/gitrepo" ]
WORKDIR /gitrepo

COPY ./release-image /scripts/release-image
RUN chmod +x /scripts/release-image
RUN ln -s /scripts/release-image /usr/local/bin/release-image

ENTRYPOINT [ "release-image" ]
CMD [ "--help" ]
