FROM ruby:2-stretch
MAINTAINER Rajko Albrecht


ENV APP_HOME /srv/ispconfig-dyndns

# Copy just the files for bundle install
ADD vendor/assets $APP_HOME/vendor/assets
ADD Gemfile       $APP_HOME/
ADD Gemfile.lock  $APP_HOME/

ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_IGNORE_MESSAGES=1 \
    BUNDLE_GITHUB__HTTPS=1 \
    NOKOGIRI_USE_SYSTEM_LIBRARIES=1 \
    BUNDLE_FROZEN=1 \
    BUNDLE_PATH=$APP_HOME/vendor/bundle \
    BUNDLE_BIN=$APP_HOME/bin \
    BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_WITHOUT=development:benchmark:test

RUN set -ex \
    && BUILD_DEPS="git \
    libcurl4-gnutls-dev libxml2-dev libxslt1-dev libgcrypt20-dev libsqlite3-dev libffi-dev libc-dev linux-kernel-headers \
    libmariadb-dev" \
    && echo "gem: --no-document" > /etc/gemrc \
    && apt-get update && apt-get install -y --no-install-recommends libxslt1.1 \
    && apt-get install -y --no-install-recommends $BUILD_DEPS \
    && bundle install --without debug \
    && apt-get purge -y --auto-remove $BUILD_DEPS

ENV RAILS_ENV=production PATH=$APP_HOME/bin:$PATH

# Copy just the files needed for assets:precompile
ADD Rakefile   $APP_HOME/
ADD config     $APP_HOME/config
ADD public     $APP_HOME/public
ADD app/assets $APP_HOME/app/assets
ADD lib/isp_exceptions  $APP_HOME/lib/isp_exceptions
ADD lib/logging  $APP_HOME/lib/logging
ADD lib/tasks $APP_HOME/lib/tasks
ADD lib/assets $APP_HOME/lib/assets
ADD . $APP_HOME
RUN cd $APP_HOME && rm -rf public/assets && rake assets:precompile DATABASE_URL=sqlite3:tmp/dummy.db SECRET_KEY_BASE=dummy

#RUN cd $APP_HOME && rake db:migrate
RUN chown -R nobody:nogroup $APP_HOME
COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/production.rb $APP_HOME/config/environments/production.rb
RUN chmod 755 /entrypoint.sh

USER nobody

WORKDIR $APP_HOME
ENV HOME $APP_HOME

EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]

