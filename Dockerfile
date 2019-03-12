FROM node:alpine
RUN yarn global add serverless && yarn cache clean

WORKDIR /var/task

ENTRYPOINT ["serverless"]
CMD ["deploy"]
