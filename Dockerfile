ARG ACCOUNT_ID=129462528407
ARG ENVIRONMENT=dev
ARG REGION

# start with our base hardened image.
FROM ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/sb-ruby-centos-26x-master-c323636-0-${ENVIRONMENT}-base-${REGION}:version-2.6.2

ENV APP_HOME /sbapp
RUN mkdir -p $APP_HOME/{tmp,log,gems}
WORKDIR $APP_HOME

# Example of installing dependencies
RUN /usr/bin/yum install -y \
	sqlite-devel \
	git \
	zlib-devel \
	gcc-c++ \
	make \
	yarn \
	&& yum clean all \
	&& rm -rf /var/cache/yum

USER sbapp

# Copy the app code to the image
COPY --chown=sbapp . $APP_HOME

# Adjusting env vars to ensure adhere to bundler's best practices for docker:
# https://bundler.io/v2.0/guides/bundler_docker_guide.html
ENV GEM_HOME=$APP_HOME/.bundle
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile
ENV BUNDLE_JOBS=4
ENV DEVISE_SECRET_KEY='ea0c9a9bce14df1cdab8850a6c59ba2811a5cc4a97a7d39b275e674f9d016d5ed5d8757f06b795444d0f1f23b7b3f98fa1a0abed04fe8b3fa904ef79efe02636'

# Do the bundle install
COPY Gemfile $APP_HOME/
COPY Gemfile.lock $APP_HOME/
RUN bundle install --no-cache --deployment --without development \
 && rm -rf ./vendor/bundle/ruby/*/bundler/gems/*/.git \
 && rm -rf ./vendor/bundle/ruby/*/cache/*.gem \
 && find ./vendor/bundle/ruby/*/gems/ -name "*.c" -delete \
 && find ./vendor/bundle/ruby/*/gems/ -name "*.o" -delete \
 && gem cleanup

# Expose the port the app listens on
EXPOSE 3000

# Run the app
CMD ./run.sh
