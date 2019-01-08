FROM alpine

RUN apk add --no-cache yarn && \
    yarn global add serverless

WORKDIR /var/task

ENTRYPOINT ["serverless"]
CMD ["deploy"]
