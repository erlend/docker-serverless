FROM lambci/lambda:build-ruby2.5

ENV ZEROMQ_VERSION="4.3.1"

RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash - && \
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo > /etc/yum.repos.d/yarn.repo && \
    yum install -y gcc-c++ make nodejs yarn mysql-devel postgresql-devel && \
    yum clean all && \
    gem update bundler && \
    yarn global add aws-sdk serverless && \
    cd /tmp && \
    curl -L https://github.com/zeromq/libzmq/releases/download/v$ZEROMQ_VERSION/zeromq-$ZEROMQ_VERSION.tar.gz \
    | tar zx && \
    cd zeromq-$ZEROMQ_VERSION && \
    ./configure && \
    make install && \
    cd .. && \
    rm -rf zeromq-$ZEROMQ_VERSION

ONBUILD COPY package.json yarn.lock /var/task/
ONBUILD RUN yarn

ONBUILD COPY Gemfile Gemfile.lock /var/task/
ONBUILD ARG BUNDLER_ARGS="--deployment --without=development:test"
ONBUILD RUN bundle install $BUNDLER_ARGS

ONBUILD COPY . /var/task/

ENTRYPOINT ["serverless"]
CMD ["deploy"]
