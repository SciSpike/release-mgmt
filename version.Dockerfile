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

COPY ./release-version /scripts/release-version
RUN chmod +x /scripts/release-version
RUN ln -s /scripts/release-version /usr/local/bin/release-version

ENTRYPOINT [ "release-version" ]
CMD [ "--help" ]
