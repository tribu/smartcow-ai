FROM python
RUN mkdir -p /app
COPY ../app /app/
WORKDIR /app/api

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["/app/api/start.sh"]


