# Nginx configuration
FROM alpine:latest AS nginx_build
ARG BTL_BACKEND
ARG BTL_DOMAIN
ENV BTL_BACKEND=${BTL_BACKEND:?"Backend API url is not set."}
ENV BTL_DOMAIN=${BTL_DOMAIN:?"Webserver domain name is not set."}
WORKDIR /build

RUN apk update -q && apk add -q gettext > /dev/null
COPY nginx.conf.template .
RUN envsubst '$BTL_BACKEND,$BTL_DOMAIN' < nginx.conf.template > nginx.conf

# Static files
FROM alpine:latest AS html_build
WORKDIR /app/build
RUN echo '<html><body>It Works!</body></html>' > index.html

# End result image
FROM nginx:stable

LABEL description="Nginx webserver that serves static files and works as reverse proxy for RESTful API."
LABEL license="MIT"
LABEL maintainer="Aleksey Chernyaev <a.chernyaev.work@gmail.com>"

COPY /private/*_CERT.pem /etc/ssl/certs/
COPY /private/*_KEY.pem /etc/ssl/private/
COPY --from=nginx_build /build/nginx.conf /etc/nginx/nginx.conf
COPY --from=html_build /app/build/ /var/www/btestlab_ui/

EXPOSE 80/tcp
EXPOSE 443/tcp

HEALTHCHECK --interval=20s --retries=3 --timeout=3s \
  CMD curl -qfs --retry 0 -o /dev/null http://localhost/healthcheck || exit 1

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]