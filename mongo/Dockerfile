# Retrieve database init scripts
FROM alpine:latest AS init_build
ARG BTL_BRANCH=main
WORKDIR /build

RUN apk update -q \
  && apk add -q git > /dev/null \
  && git clone -q -b $BTL_BRANCH --depth 1 --single-branch https://github.com/a1black/btestlab-rest.git . > /dev/null

# End result image
FROM mongo:5-focal

COPY mongod.conf /etc/mongod.conf
COPY mongosh.conf /etc/mongosh.conf
COPY --from=init_build /build/init/db/ /docker-entrypoint-initdb.d/

HEALTHCHECK --interval=20s --retries=3 --start-period=60s --timeout=3s \
  CMD echo 'db.runCommand("ping").ok' | mongosh localhost:27017/test &> /dev/null