FROM ruby:2.5.3

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock /usr/src/app/

# Updating apt-get
# Installing `sudo`
# Installing bundler
# Installing gems
RUN apt-get update && \
		apt-get install -y --no-install-recommends sudo && \
		gem install bundler && \
		bundle install --jobs=20

# Installing jsRuntime
RUN wget https://deb.nodesource.com/setup_6.x && \
		chmod +x setup_6.x && \
		./setup_6.x && \
		apt-get install -y nodejs

# Deletes any possible server PID that was running
# And starts the server in mode development in 0.0.0.0:3000
## DEVELOPMENT
CMD rm -rf /usr/src/app/tmp/pids/* && \
		bundle exec rails server -b 0.0.0.0
