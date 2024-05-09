# Base Image
FROM ruby:3.2.2

# Encoding
# C.UTF8 locale supports Computer English language
ENV LANG C.UTF-8
ENV RAILS_ENV=production

RUN apt-get update -qq && \
  apt-get install -y curl \
  build-essential \
  libpq-dev    \
  libxml2-dev  \
  libxslt1-dev \
  imagemagick  \
  cron         \
  vim

# --------------------------
# INSTALL LAST VERSION OF postgresql-client
# --------------------------
RUN apt-get install -y lsb-release
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >>  /etc/apt/sources.list.d/pgdg.list     &&  \
  sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
  apt-get install wget ca-certificates && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update -qq && \
  apt-get install -y postgresql-client

# --------------------------
# INSTALL NODEJS BY NVM
# --------------------------
ARG NODE_VERSION=10.24.1
ARG NVM_DIR=/usr/local/nvm

# https://github.com/creationix/nvm#install-script
RUN mkdir $NVM_DIR && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v
# --------------------------
# end NODEJS
# --------------------------

# Install YARN
RUN npm install -g yarn

# Set working directory
WORKDIR /app

RUN gem install bundler -v 2.3.7 --no-document

# copy Gemfile and Gemfile.lock and install gems before copying rest of the application
# so the steps will be cached until there won't be any changes in Gemfile
COPY Gemfile* ./

ENV BUNDLER_WITHOUT development test
RUN bundle install --jobs 4 --retry 3

COPY . .

RUN yarn install
RUN npx update-browserslist-db@1.0.3
RUN SECRET_KEY_BASE=1 bundle exec rails assets:precompile

ENTRYPOINT [ "./deploy/docker-entrypoint.sh" ]

CMD bundle exec rails s -p 3000 -b '0.0.0.0'
