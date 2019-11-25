FROM ruby:2.6.2-stretch

ENV RAILS_ROOT /project

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  nodejs \
  libpq-dev && \
  mkdir -p $RAILS_ROOT && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log

WORKDIR $RAILS_ROOT

ENV RAILS_ENV='production'

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install --jobs 20 --retry 5 --without development test
# RUN bundle install --jobs 20 --retry 5

COPY . .
RUN bundle exec rake assets:precompile

EXPOSE 3000

# ENTRYPOINT [ "bundle", "exec" ]

CMD ["bundle", "exec", "rails", "s"]
