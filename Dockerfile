FROM scispike/release-mgmt:1.0.0

RUN mkdir /scripts
COPY match /scripts/match
RUN chmod +x /scripts/match
RUN ln -s /scripts/match /usr/local/bin/match

RUN mkdir /gitrepo
VOLUME [ "/gitrepo" ]
WORKDIR /gitrepo

COPY ./release* /scripts/
RUN rm /scripts/release-this

RUN chmod +x /scripts/*

RUN mkdir -p /root/.ssh

COPY .docker.entrypoint.sh /
RUN chmod +x /.docker.entrypoint.sh

ENTRYPOINT [ "/.docker.entrypoint.sh" ]
CMD [ "--help" ]
