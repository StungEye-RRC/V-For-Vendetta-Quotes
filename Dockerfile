FROM ruby:2.6.5-buster

ENV RAILS_ROOT /project

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  nodejs \
  yarn \
  libpq-dev && \
  mkdir -p $RAILS_ROOT && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log

WORKDIR $RAILS_ROOT

#ENV RAILS_ENV='development'
ENV RAILS_ENV='production'
ENV SECRET_KEY_BASE='2502e3fba52ad66fcef930dcf59ad9210d3e1a1aceadd6077c7498d05519656c9face8929c52708b06d3c5de98f3e8d397f2993324c6f6c1750635214e20c040'

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install --jobs 20 --retry 5 --without development test

COPY package.json package.json
COPY yarn.lock yarn.lock

RUN yarn install --check-files

COPY . .

RUN bundle exec rails assets:precompile

# EXPOSE 3000

# CMD ["bundle", "exec", "rails", "s"]
