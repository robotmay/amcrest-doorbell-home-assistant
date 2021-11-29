FROM ruby:3-alpine

RUN bundle config --global frozen 1

WORKDIR /usr/src/bus

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
CMD ["./party_bus.rb"]
