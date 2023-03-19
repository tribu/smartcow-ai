FROM nginx

ENV API_HOSTNAME=api
ENV NODE_HOSTNAME=node
COPY ./default.conf /default.conf.template
CMD ["/bin/sh" , "-c" , "envsubst < /default.conf.template > /etc/nginx/conf.d/default.conf  && exec nginx -g 'daemon off;'"]

