## BUILD Image ##
#FROM node:14.11.0-buster-slim AS builder

#WORKDIR /usr/src/app

#COPY ../btestlab-webapp/package*.json ./

#RUN npm install
#RUN npm ci --only=production

#COPY ../btestlab-webapp .

## PROD Image ##
FROM nginx:1.19.2

COPY --chown=nginx:nginx ./nginx.conf /etc/nginx/nginx.conf
#COPY --chown=nginx:nginx --from=builder /usr/src/app/build /var/share/nginx/html

RUN adduser --system --group --home /home/app-data app-data \
    && usermod -a -G app-data nginx \
    && mkdir -p /home/app-data/image \
    && chown -R app-data:app-data /home/app-data \
    && chmod -R 755 /home/app-data

USER app-data
