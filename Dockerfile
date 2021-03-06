FROM ruby:2.3
MAINTAINER Rich Daley <rich@fishpercolator.co.uk>
ENV REFRESHED_AT 2016-03-08

# This line is needed for JavaScript testing with headless+capybara-webkit
RUN apt-get update -y && apt-get install less xvfb qt5-default libqt5webkit5-dev -y && apt-get clean

# Mailchimp's certificate isn't trusted on Debian 8 - make it so
ADD vendor/mailchimp-cert.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN adduser --uid 1001 --disabled-password --gecos "" rails

RUN gem install bundler

ENV APP_HOME /usr/src/gsoh
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile BUNDLE_JOBS=2 BUNDLE_PATH=/bundle

RUN bundle install

ENV RAILS_ENV       production
ENV DOMAIN_NAME     localhost
# NOTE: ALWAYS override this or your sessions will be insecure!
ENV SECRET_KEY_BASE 37024e326f9b8286834b82432e86b807deeb26d707a254f08e747f551783f30806d2ac135141d8761bd923a69ab9a89326542f42e21511304587193a56da632a
ENV WEB_CONCURRENCY 2

ADD . $APP_HOME

RUN RAILS_ENV=production bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
