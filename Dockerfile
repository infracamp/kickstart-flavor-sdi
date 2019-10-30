FROM infracamp/kickstart-flavor-base:testing
LABEL maintainer="Matthias Leuffen <m@tth.es>"

# Set from hub.docker.com
ENV IMAGE_NAME "${IMAGE_NAME}"
ENV KICK_HTTP_PORT "80"

ADD / /kickstart
RUN chmod -R 755 /kickstart && /kickstart/flavor/flavor-build.sh

## Entrypoint is used from base image