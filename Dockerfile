FROM ruby:3-slim

WORKDIR /usr/src/app

COPY . .
RUN bundle install

CMD ["ruby", "./party_bus.rb"]
