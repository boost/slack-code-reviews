FROM ruby:2.6.5-alpine AS build-env

ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="mariadb-dev yaml-dev zlib-dev"
ARG RUBY_PACKAGES="tzdata"

WORKDIR /app

# install packages
RUN apk add --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

COPY Gemfile Gemfile.lock ./

# install rubygem
RUN gem install bundler -v $(tail -n1 Gemfile.lock) \
    && bundle config --global frozen 1 \
    && bundle config --global without development:test \
    && bundle install --jobs=4 --retry=3 \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf $GEM_HOME/cache/*.gem \
    && find $GEM_HOME/gems/ -name "*.c" -delete \
    && find $GEM_HOME/gems/ -name "*.o" -delete

############### Build step done ###############

FROM ruby:2.6.5-alpine

ARG PACKAGES="tzdata mysql-client mariadb-dev"

WORKDIR /app

# install packages
RUN apk add --no-cache $PACKAGES

COPY --from=build-env $GEM_HOME $GEM_HOME
COPY . .

ARG RAILS_ENV="production"
ENV RAILS_ENV=$RAILS_ENV

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
