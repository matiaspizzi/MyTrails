FROM ruby:3.3.6-alpine3.21

RUN apk add --no-cache build-base postgresql-dev nodejs yarn

WORKDIR /myapp

COPY Gemfile  ./

RUN bundle install

COPY . .

RUN apk add --no-cache bash

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
