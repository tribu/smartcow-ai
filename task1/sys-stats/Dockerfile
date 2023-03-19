FROM node:16.9.1-alpine
RUN mkdir -p /app
COPY ../app /app/
WORKDIR /app/sys-stats

RUN npm install

EXPOSE 3000

ENTRYPOINT ["/app/sys-stats/start.sh"]