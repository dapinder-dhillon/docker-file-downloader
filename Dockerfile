FROM python:3.5.6-alpine3.8

RUN pip install --upgrade pip && \
    pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

RUN apk add --update bash && rm -rf /var/cache/apk/*

ENV BUCKET_PATH tejas-test/vtw/
ENV SHARED_PATH /usr/local/application/contributor

CMD aws s3 sync "s3://${BUCKET_PATH}" ${SHARED_PATH}