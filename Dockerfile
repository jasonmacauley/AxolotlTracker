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

#RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#     apt-get update && apt-get install yarn


ENV APP_HOME /sbapp
RUN mkdir -p $APP_HOME/{tmp,log,gems}
WORKDIR $APP_HOME
COPY Gemfile /sbapp/Gemfile
COPY Gemfile.lock /sbapp/Gemfile.lock
RUN gem install bundler:2.0.2
RUN bundle install
COPY . /sbapp

ENV DEVISE_SECRET_KEY='ea0c9a9bce14df1cdab8850a6c59ba2811a5cc4a97a7d39b275e674f9d016d5ed5d8757f06b795444d0f1f23b7b3f98fa1a0abed04fe8b3fa904ef79efe02636'

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
