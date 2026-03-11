FROM ruby:3.1.2-alpine AS builder
WORKDIR /app
RUN apk add --no-cache tzdata build-base nodejs postgresql-dev
COPY Gemfile* .
RUN bundle install
COPY . .
RUN bundle exec rake assets:precompile

FROM ruby:3.1.2-alpine AS runner
WORKDIR /app
RUN apk add --no-cache tzdata postgresql-dev
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app

EXPOSE 3000
CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb"]
