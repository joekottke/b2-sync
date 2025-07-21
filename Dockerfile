FROM python:3-alpine

RUN apk add -u --no-cache bash && \
    pip install --no-cache-dir b2

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

VOLUME [ "/source", "/destination" ]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]