FROM ruby:3.1.2-alpine AS builder
ENV RAILS_ENV=production
WORKDIR /app
RUN apk add tzdata build-base nodejs postgresql-dev
COPY Gemfile* .
RUN bundle install
COPY . .
RUN bundle exec rake assets:precompile
FROM ruby:3.1.2-alpine AS runner
ENV RAILS_ENV=production
WORKDIR /app
RUN apk add tzdata postgresql-dev
# We copy over the entire gems directory for our builder image, containing the already built artifact
COPY . .
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/public/assets/ /app/public/assets/

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
