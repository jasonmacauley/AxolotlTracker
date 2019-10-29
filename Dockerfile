ARG ACCOUNT_ID=129462528407
ARG ENVIRONMENT=dev
ARG REGION

# start with our base hardened image.
FROM ruby:2.6.2

RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    git \
    zlib1g \
    gcc \
    make \
    yarn

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs

ENV APP_HOME /sbapp
RUN mkdir -p $APP_HOME/{tmp,log,gems}
WORKDIR $APP_HOME
COPY Gemfile /sbapp/Gemfile
COPY Gemfile.lock /sbapp/Gemfile.lock
RUN gem install bundler:2.0.2
RUN bundle install
COPY . /sbapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
