FROM ruby:3-slim

RUN bundle config --global frozen 1

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
CMD ["./party_bus.rb"]
